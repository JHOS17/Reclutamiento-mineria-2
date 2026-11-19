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
