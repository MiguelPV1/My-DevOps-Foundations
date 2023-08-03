#### VPC FOR OHIO ####
resource "aws_vpc" "ohio_vpc" {
  provider             = aws.private
  cidr_block           = var.vpc_cidrs[1]
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-vpc"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_subnet" "ohio_private_subnets" {
  provider = aws.private
  count    = length(var.ohio_private_subnet_cidrs)

  vpc_id            = aws_vpc.ohio_vpc.id
  cidr_block        = element(var.ohio_private_subnet_cidrs, count.index)
  availability_zone = element(var.ohio_subnet_azs, count.index)

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-subnet-private${count.index + 1}"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_security_group" "ohio_sg_mysql" {
  provider    = aws.private
  name        = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-sg-mysql"
  description = "Security group for MySQL"
  vpc_id      = aws_vpc.ohio_vpc.id

  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-sg-mysql"
    Owner = var.owner
    App   = var.app
  }
}
