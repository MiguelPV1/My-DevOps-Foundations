# # Provider
# provider "aws" {
#   region = "us-east-1"
#   access_key = ""
#   secret_key = ""
# }

# -> Resource estructure <-
# resource "<provider>_<resource_type>" "name_for_terraform" {
#   config options...
#   key = "value"
#   key2 = "another value"
# }


# # 1- EC2
# resource "aws_instance" "my-first-server" {
#   ami = "ami-085925f297f89fce1"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "ubuntu"
#   }
# }


# # 2- VPC
# resource "aws_vpc" "first-vpc" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "production"
#   }
  
# }
# # 2.1- Subnet
# resource "aws_subnet" "subnet-1" {
#   vpc_id = aws_vpc.first-vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "prod-subnet"
#   }
# }

# resource "aws_vpc" "second-vpc" {
#   cidr_block = "10.1.0.0/16"

#   tags = {
#     Name = "production"
#   }
  
# }
# resource "aws_subnet" "subnet-2" {
#   vpc_id = aws_vpc.second-vpc.id
#   cidr_block = "10.1.1.0/24"

#   tags = {
#     Name = "dev-subnet"
#   }
# }


