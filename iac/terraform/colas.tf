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
