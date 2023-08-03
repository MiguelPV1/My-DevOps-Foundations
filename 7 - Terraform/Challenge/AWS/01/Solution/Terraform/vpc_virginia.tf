#### VPC FOR N. VIRGINIA ####
resource "aws_vpc" "virginia_vpc" {
  provider             = aws.public
  cidr_block           = var.vpc_cidrs[0]
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-vpc"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_subnet" "virginia_public_subnets" {
  provider = aws.public
  count    = length(var.virginia_public_subnet_cidrs)

  vpc_id                  = aws_vpc.virginia_vpc.id
  cidr_block              = element(var.virginia_public_subnet_cidrs, count.index)
  availability_zone       = element(var.virginia_subnet_azs, count.index)
  map_public_ip_on_launch = true #-> Handles public IP assigment

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-subnet-public${count.index + 1}"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_internet_gateway" "virginia_igw" {
  provider = aws.public
  vpc_id   = aws_vpc.virginia_vpc.id

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-igw"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_route_table" "virginia_public_rtb" {
  provider = aws.public
  vpc_id   = aws_vpc.virginia_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virginia_igw.id
  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-rtb-public"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_route_table_association" "virginia_subnet_asso" {
  provider = aws.public
  count    = length(var.virginia_public_subnet_cidrs)

  subnet_id      = element(aws_subnet.virginia_public_subnets[*].id, count.index)
  route_table_id = aws_route_table.virginia_public_rtb.id
}

resource "aws_security_group" "virginia_sg_linux" {
  provider    = aws.public
  name        = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-sg-linux"
  description = "Security group for my Web Server"
  vpc_id      = aws_vpc.virginia_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-sg-linux"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_security_group" "virginia_sg_windows" {
  provider    = aws.public
  name        = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-sg-windows"
  description = "Security group for MySQL Workbench"
  vpc_id      = aws_vpc.virginia_vpc.id

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-sg-windows"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_network_interface" "web_server_nic" {
  provider = aws.public

  subnet_id       = aws_subnet.virginia_public_subnets[0].id
  private_ips     = [var.virginia_nic_ips[0]]
  security_groups = [aws_security_group.virginia_sg_linux.id]

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-eni-linux"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_network_interface" "mysql_workbench_nic" {
  provider = aws.public

  subnet_id       = aws_subnet.virginia_public_subnets[1].id
  private_ips     = [var.virginia_nic_ips[1]]
  security_groups = [aws_security_group.virginia_sg_windows.id]

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-eni-windows"
    Owner = var.owner
    App   = var.app
  }
}
