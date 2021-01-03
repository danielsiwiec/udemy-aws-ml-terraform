data "aws_iam_policy_document" "kinesis_analytics_policy_document" {
  statement {
    actions = [
      "firehose:Describe*",
      "firehose:Get*",
      "firehose:Put*"
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.ticker_demo.arn,
      aws_kinesis_firehose_delivery_stream.ticker_analytics_demo.arn
    ]

    effect = "Allow"
  }
}

resource "aws_iam_policy" "kinesis_analytics_iam_policy" {
  name   = "kinesis_analytics_iam_policy"
  policy = data.aws_iam_policy_document.kinesis_analytics_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kenisis_analytics_role_attachment" {
  role       = aws_iam_role.kinesis_analytics_role.name
  policy_arn = aws_iam_policy.kinesis_analytics_iam_policy.arn
}

resource "aws_iam_role" "kinesis_analytics_role" {
  name = "kinesis_analytics_role"
  tags = var.common_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "kinesisanalytics.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}