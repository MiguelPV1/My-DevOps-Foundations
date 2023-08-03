#### RDS Instance ####
resource "aws_db_instance" "mysql" {
  provider = aws.private

  identifier             = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-db"
  engine                 = var.mysql_details.engine
  engine_version         = var.mysql_details.engine_version
  instance_class         = var.mysql_details.class
  username               = var.mysql_details.user
  password               = var.mysql_details.psswd
  db_name                = var.mysql_details.db
  allocated_storage      = var.mysql_details.storage_size
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.id
  availability_zone      = var.ohio_subnet_azs[0]
  vpc_security_group_ids = [aws_security_group.ohio_sg_mysql.id]
  skip_final_snapshot    = true

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-db"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  provider = aws.private

  name        = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-db-sngp"
  description = "DB subnet group for MySQL"
  subnet_ids  = [for subnet in aws_subnet.ohio_private_subnets : subnet.id]

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-db-sngp"
    Owner = var.owner
    App   = var.app
  }
}

# EC2 Test Instance
# resource "aws_instance" "test_mysql" {
#   provider = aws.private

#   ami = "ami-024e6efaf93d85776"
#   instance_type = "t2.micro"
#   availability_zone =  var.ohio_subnet_azs[0]
#   key_name = "devops-ch01"
#   subnet_id = aws_subnet.ohio_private_subnets[0].id
#   vpc_security_group_ids = [ aws_security_group.ohio_sg_mysql.id ]

#   tags = {
#     Name = "${var.app_env}-${var.app_id}-${var.app_region_name[1]}-test-db"
#     Owner = var.owner
#     App = var.app
#   }
# }
