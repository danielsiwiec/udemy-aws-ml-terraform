resource "aws_kinesis_firehose_delivery_stream" "ticker_demo" {
  name        = "ticker_demo"
  destination = "extended_s3"
  tags        = var.common_tags

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = aws_s3_bucket.dans-ml.arn
    prefix              = "ticker_demo/"
    error_output_prefix = "ticker_demo_error/"
    buffer_size         = 1
    buffer_interval     = 60

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.kinesis_logs.name
      log_stream_name = aws_cloudwatch_log_stream.kinesis_logs.name
    }
  }
}
