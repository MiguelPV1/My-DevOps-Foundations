provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
  # token = "" #Para el sandobox de AWs
}

#######
# resource <recurso> <alias>
resource "aws_s3_bucket" "demo-s3" {
  bucket = "demo-s3-terraform-clase"
  # bucket = "demo-s3-terraform-clase2"
  tag = {
    Name = "My bucket"
    Environment = "Dev"
  }
}

# - terraform init:  inicializar terraform (descargar plug-in)
# - terraform validate: validar que el template esta correcto
# - terraform plan: genera las modificaciones o la planeacion del aprovisionamiento
# - terraform apply --auto-approve: crear recursos y auto aprueba?
# - terraform destroy --auto-approve: destruir recursos y auto aprueba?
# - terraform fmt --recursive: acomoda los archivos (pretty) de manera recursiva para archivo de terraform