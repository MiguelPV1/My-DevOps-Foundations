provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
  # token = "" #Para el sandobox de AWS
}

module "s3_backend" {
  source = "./modulo_s3"
  s3_bucket = "tf-holamundo-s3"
}