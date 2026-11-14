output "web_url" {
  value = "http://${aws_lb.main.dns_name}"
}

output "asg_name" {
  value = aws_autoscaling_group.web.name
}

output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "db_secret_arn" {
  value = aws_db_instance.main.master_user_secret[0].secret_arn
}

output "cvs_bucket" {
  value = aws_s3_bucket.cvs.id
}

output "cvs_replica_bucket" {
  value = aws_s3_bucket.cvs_replica.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}

output "dashboard_name" {
  value = aws_cloudwatch_dashboard.main.dashboard_name
}
