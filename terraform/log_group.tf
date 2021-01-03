resource "aws_cloudwatch_log_group" "kinesis_logs" {
  name = "kinesis_logs"

  tags = var.common_tags
}

resource "aws_cloudwatch_log_stream" "kinesis_logs" {
  name           = "kinesis_logs"
  log_group_name = aws_cloudwatch_log_group.kinesis_logs.name
}
