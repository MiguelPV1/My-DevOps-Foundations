output "mysql_enpoint" {
  description = "MySQL Endpoint"
  value       = aws_db_instance.mysql.address
}

output "web_server_public_dns" {
  description = "Web Server Public DNS"
  value       = aws_eip.web_server_eip.public_dns
}

output "mysql_workbench_dns" {
  description = "MySQL Workbench Public DNS"
  value       = aws_instance.mysql_workbench.public_dns
}

output "mysql_workbench_psswd" {
  description = "MySQL Workbench Administrator Password"
  value       = rsadecrypt(aws_instance.mysql_workbench.password_data, file(var.virginia_pem))
}