provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

variable "subnet_prefix" {
  description = "CIDR block for the subnet" # Optional
  # default = "10.0.1.0/24"  #Optional: if not assiganed Terraform will ask for it in prompt
  # type = string  #Optional
}


# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id

}

# 3. Create Custom Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.prod-vpc.id
  # cidr_block = var.subnet_prefix[0]
  cidr_block = var.subnet_prefix[0].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    # Name = "prod-subnet"
    Name = var.subnet_prefix.name
  }
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.prod-vpc.id
  # cidr_block = var.subnet_prefix[1]
  cidr_block = var.subnet_prefix[1].cidr_block
  availability_zone = "us-east-1a"

  tags = {
    # Name = "dev-subnet"
    Name = var.subnet_prefix[1].name
  }
}

# 5. Associate Subnet with Route Table
resource "aws_route_table_association" "rta" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow ports 22, 80, 443
resource "aws_security_group" "allow_web" {
  name = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id = aws_vpc.prod-vpc.id
  
  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0 # Allow any port
    to_port = 0
    protocol = "-1" # Allow any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_web"
  }
}

# 7. Create a Network Interface with an IP in the subnet that was created in Step 4
resource "aws_network_interface" "web-server-nic" {
  subnet_id = aws_subnet.subnet-1.id
  private_ips = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

# 8. Assign an elastic IP to the network interface created in Step 7
resource "aws_eip" "eip" {
  vpc = true
  network_interface = aws_network_interface.web-server-nic.id
  associate_with_private_ip = "10.0.1.50"

  depends_on = [ aws_internet_gateway.gw ]  # Must be created after the internet gateway
}

# 9. Create Ubuntu server and install/enable apache2
resource "aws_instance" "web-server-instance" {
  ami = "ami-085925f297f89fce1"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-nic.id
  }

  user_data = <<-EOF
    #!/bin/bash

    sudo apt-get update -y
    sudo apt install -y apache2
    sudo systemctl start apache2

    sudo bash -c 'echo your very first web server > /var/www/html/index.html'
  EOF

  tags = {
    Name = "web-server"
  }
}

# 10. Create Key pair for EC2
# ???

# 11. Outputs
output "server_public_ip" {
  value = aws_eip.eip.public_ip
}

output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip
}

output "server_id" {
  value = aws_instance.web-server-instance.id
}


# --> COMANDS <--
# terraform state list: list all resources created with terraform
# terraform state show <resource = aws_eip.one>: shows details of that resource
# terraform output: prints all the outputs
# terraform refresh: refresh all the state and runn all outputs without applying any changes
# terraform destroy -target aws_instance.web-server-instance: destroys just the especified resource
# terraform apply -target aws_instance.web-server-instance: deploys just the especified resource
# terraform apply -var "subnet_prefix=10.0.1.0/24": deploy infraestructure with a variable
# terraform apply -var-file example.tfvars: deploy infraestructure with variables defined in the especified file
# 
# 