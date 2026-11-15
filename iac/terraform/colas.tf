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

output "cola_cv_url" {
  value = aws_sqs_queue.cv.url
}
