resource "aws_sns_topic" "alerts" {
  name              = "${local.name}-alertas"
  kms_master_key_id = aws_kms_key.main.arn
}

resource "aws_sns_topic_policy" "alerts" {
  arn = aws_sns_topic.alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AlarmasCloudWatch"
        Effect    = "Allow"
        Principal = { Service = "cloudwatch.amazonaws.com" }
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.alerts.arn
        Condition = {
          StringEquals = { "aws:SourceAccount" = local.account_id }
        }
      },
      {
        Sid       = "SoloTls"
        Effect    = "Deny"
        Principal = "*"
        Action    = "sns:Publish"
        Resource  = aws_sns_topic.alerts.arn
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "email" {
  count     = local.has_email ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

locals {
  alarm_actions = [aws_sns_topic.alerts.arn]

  simple_alarms = {
    objetivos-no-saludables = {
      namespace  = "AWS/ApplicationELB"
      metric     = "UnHealthyHostCount"
      statistic  = "Maximum"
      threshold  = 0
      dimensions = { LoadBalancer = aws_lb.main.arn_suffix, TargetGroup = aws_lb_target_group.web.arn_suffix }
    }
    cpu-aplicacion-alta = {
      namespace  = "AWS/EC2"
      metric     = "CPUUtilization"
      statistic  = "Average"
      threshold  = 80
      dimensions = { AutoScalingGroupName = aws_autoscaling_group.web.name }
    }
    cpu-base-datos-alta = {
      namespace  = "AWS/RDS"
      metric     = "CPUUtilization"
      statistic  = "Average"
      threshold  = 80
      dimensions = { DBInstanceIdentifier = aws_db_instance.main.identifier }
    }
    conexiones-base-datos = {
      namespace  = "AWS/RDS"
      metric     = "DatabaseConnections"
      statistic  = "Maximum"
      threshold  = var.db_max_connections_alarm
      dimensions = { DBInstanceIdentifier = aws_db_instance.main.identifier }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "simple" {
  for_each            = local.simple_alarms
  alarm_name          = "${local.name}-${each.key}"
  namespace           = each.value.namespace
  metric_name         = each.value.metric
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  dimensions          = each.value.dimensions
  comparison_operator = "GreaterThanThreshold"
  period              = 60
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "storage_db" {
  alarm_name          = "${local.name}-almacenamiento-base-datos"
  namespace           = "AWS/RDS"
  metric_name         = "FreeStorageSpace"
  statistic           = "Minimum"
  threshold           = 2147483648
  dimensions          = { DBInstanceIdentifier = aws_db_instance.main.identifier }
  comparison_operator = "LessThanThreshold"
  period              = 300
  evaluation_periods  = 1
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "latency_p95" {
  alarm_name          = "${local.name}-latencia-p95"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "TargetResponseTime"
  extended_statistic  = "p95"
  threshold           = 3
  dimensions          = { LoadBalancer = aws_lb.main.arn_suffix }
  comparison_operator = "GreaterThanThreshold"
  period              = 60
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions
}

resource "aws_cloudwatch_metric_alarm" "errors_5xx" {
  alarm_name          = "${local.name}-errores-5xx"
  alarm_description   = "Mas del 5% de las respuestas son 5xx"
  comparison_operator = "GreaterThanThreshold"
  threshold           = 5
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "notBreaching"
  alarm_actions       = local.alarm_actions
  ok_actions          = local.alarm_actions

  metric_query {
    id          = "porcentaje"
    expression  = "IF(solicitudes > 0, 100 * (errores_alb + errores_app) / solicitudes, 0)"
    label       = "Porcentaje de errores 5xx"
    return_data = true
  }

  metric_query {
    id = "errores_alb"

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_ELB_5XX_Count"
      stat        = "Sum"
      period      = 60
      dimensions  = { LoadBalancer = aws_lb.main.arn_suffix }
    }
  }

  metric_query {
    id = "errores_app"

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "HTTPCode_Target_5XX_Count"
      stat        = "Sum"
      period      = 60
      dimensions  = { LoadBalancer = aws_lb.main.arn_suffix }
    }
  }

  metric_query {
    id = "solicitudes"

    metric {
      namespace   = "AWS/ApplicationELB"
      metric_name = "RequestCount"
      stat        = "Sum"
      period      = 60
      dimensions  = { LoadBalancer = aws_lb.main.arn_suffix }
    }
  }
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.name}-plataforma"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title  = "Solicitudes y errores del ALB"
          region = var.aws_region
          stat   = "Sum"
          period = 60
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix],
            [".", "HTTPCode_Target_5XX_Count", ".", "."],
            [".", "HTTPCode_ELB_5XX_Count", ".", "."]
          ]
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "Latencia p95 del ALB"
          region  = var.aws_region
          stat    = "p95"
          period  = 60
          metrics = [["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix]]
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 24
        height = 6
        properties = {
          title  = "CPU de EC2 y RDS"
          region = var.aws_region
          stat   = "Average"
          period = 60
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", aws_autoscaling_group.web.name],
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", aws_db_instance.main.identifier]
          ]
        }
      }
    ]
  })
}
