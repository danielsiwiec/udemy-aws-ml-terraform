resource "aws_s3_bucket" "dans-ml" {
  bucket = "dans-ml"
  acl    = "private"

  tags = var.common_tags
}