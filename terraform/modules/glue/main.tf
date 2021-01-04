resource "aws_glue_catalog_database" "ml_glue_database" {
  name = "ml_glue_database"
}

resource "aws_glue_crawler" "ml_glue_crawler" {
  database_name = aws_glue_catalog_database.ml_glue_database.name
  name          = "ml_glue_crawler"
  role          = aws_iam_role.glue_crawler.arn

  s3_target {
    path = "s3://${var.bucket_name}"
  }

  tags = var.tags
}

resource "aws_iam_role_policy" "glue_crawler" {
  name = "glue_crawler"
  role = aws_iam_role.glue_crawler.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Resource": [
          "${var.bucket_arn}*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "AWSGlueServiceRole" {
  role       = aws_iam_role.glue_crawler.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role" "glue_crawler" {
  name = "glue_crawler"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "glue.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF

  tags = var.tags
}