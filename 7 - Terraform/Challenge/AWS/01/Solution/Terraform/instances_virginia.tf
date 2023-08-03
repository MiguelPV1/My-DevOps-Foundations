#### EC2 INSTANCES ####
resource "aws_instance" "web_server" {
  provider = aws.public

  ami               = var.web_server_details.ami #->Mejora: Buscar AMI con Terraform!
  instance_type     = var.web_server_details.type
  availability_zone = var.virginia_subnet_azs[0]
  key_name          = var.web_server_details.key
  depends_on        = [aws_db_instance.mysql]
  # subnet_id = aws_subnet.virginia_public_subnets[0].id #-> Defined by the network interface
  # vpc_security_group_ids = [ aws_security_group.virginia_sg_linux.id ] #-> Defined by the network interface
  user_data = base64encode(templatefile(var.web_server_details.code,
    {
      db_endpoint = aws_db_instance.mysql.address,
      db_user     = var.mysql_details.user,
      db_psswd    = var.mysql_details.psswd,
    }
  ))

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_server_nic.id
  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-linux"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_eip" "web_server_eip" {
  provider = aws.public

  # vpc = true
  network_interface         = aws_network_interface.web_server_nic.id
  associate_with_private_ip = var.virginia_nic_ips[0]
  depends_on                = [aws_internet_gateway.virginia_igw]

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-linux-eip"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_instance" "mysql_workbench" {
  provider = aws.public

  ami               = var.mysql_workbench_details.ami
  instance_type     = var.mysql_workbench_details.type
  availability_zone = var.virginia_subnet_azs[1]
  key_name          = var.mysql_workbench_details.key
  get_password_data = true
  # subnet_id = aws_subnet.virginia_public_subnets[1].id #-> Defined by the network interface
  # vpc_security_group_ids = [ aws_security_group.virginia_sg_windows.id ] #-> Defined by the network interface

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.mysql_workbench_nic.id
  }

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-windows"
    Owner = var.owner
    App   = var.app
  }
}

# Instance Scripts location: cd /var/lib/cloud/instance/scripts/
