locals {
  colas = {
    cv = "${local.name}-procesar-cv"
  }
}

resource "aws_sqs_queue" "cv_dlq" {
  name                      = "${local.colas.cv}-dlq"
  kms_master_key_id         = aws_kms_key.main.arn
  message_retention_seconds = 1209600
}

resource "aws_sqs_queue" "cv" {
  name                       = local.colas.cv
  kms_master_key_id          = aws_kms_key.main.arn
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.cv_dlq.arn
    maxReceiveCount     = 5
  })
}

resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private[0].id]
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = {
    Name = "${local.name}-endpoint-secretsmanager"
  }
}

output "cola_cv_url" {
  value = aws_sqs_queue.cv.url
}

resource "aws_cloudwatch_log_group" "lambda" {
  for_each          = toset(["procesar-cv"])
  name              = "/aws/lambda/${local.name}-${each.value}"
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.main.arn
}

resource "aws_iam_role" "procesar_cv" {
  name = "${local.name}-lambda-procesar-cv"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "procesar_cv_vpc" {
  role       = aws_iam_role.procesar_cv.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "procesar_cv" {
  name = "permisos-procesar-cv"
  role = aws_iam_role.procesar_cv.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "Registros"
        Effect   = "Allow"
        Action   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "${aws_cloudwatch_log_group.lambda["procesar-cv"].arn}:*"
      },
      {
        Sid      = "LeerCola"
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.cv.arn
      },
      {
        Sid      = "LeerCvs"
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:GetObjectVersion"]
        Resource = "${aws_s3_bucket.cvs.arn}/cvs/*"
      },
      {
        Sid      = "SecretoBaseDatos"
        Effect   = "Allow"
        Action   = "secretsmanager:GetSecretValue"
        Resource = local.db_activa.master_user_secret[0].secret_arn
      },
      {
        Sid      = "Cifrado"
        Effect   = "Allow"
        Action   = ["kms:Decrypt", "kms:GenerateDataKey"]
        Resource = aws_kms_key.main.arn
      },
      {
        Sid      = "Trazas"
        Effect   = "Allow"
        Action   = ["xray:PutTraceSegments", "xray:PutTelemetryRecords"]
        Resource = "*"
      }
    ]
  })
}
