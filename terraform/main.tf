module "jupyter" {
  source = "./modules/ec2"
  allowed_ip = var.my_ip
  key_name = aws_key_pair.public-key.id
  tags = var.common_tags
}

output "jupyter_ssh_tunnel" {
  value = "ssh ec2-user@${module.jupyter.public_dns} -L 8888:localhost:8888"
}

module "emr" {
  source = "./modules/emr"
  allowed_ip = var.my_ip
  key_name = aws_key_pair.public-key.id
  tags = var.common_tags
}

module "glue" {
  source = "./modules/glue"
  bucket_name = aws_s3_bucket.dans-ml.bucket
  bucket_arn = aws_s3_bucket.dans-ml.arn
  tags = var.common_tags
}

module "kinesys" {
  source = "./modules/kinesys"
  tags = var.common_tags
  bucket_arn = aws_s3_bucket.dans-ml.arn
}