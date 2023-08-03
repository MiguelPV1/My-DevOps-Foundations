#### App variables ####
variable "app_env" {
  description = "App Environment"
  type        = string
}
variable "app_id" {
  description = "App Identifier"
  type        = string
}
variable "app_region" {
  description = "Regions to deploy the App in"
  type        = list(string)
}
variable "app_region_name" {
  description = "Region names to deploy the App in"
  type        = list(string)
}
variable "owner" {
  description = "Owner of the App"
  type        = string
}
variable "app" {
  description = "Name of the App"
  type        = string
}
variable "my_ip" {
  description = "Administrator IP"
  type        = string
}
variable "virginia_pem" {
  description = "Location of the viginian pem key"
  type        = string
}


#### VPCs variables ####
variable "vpc_cidrs" {
  description = "CIDRs of the VPCs"
  type        = list(string)
}

variable "virginia_subnet_azs" {
  description = "Availability zones of the Public VPC"
  type        = list(string)
}
variable "virginia_public_subnet_cidrs" {
  description = "CIDRs for the public subnets of the Public VPC"
  type        = list(string)
}
variable "virginia_nic_ips" {
  description = "IP for the Network Interface of the Instances deployed on the Public VPC "
  type        = list(string)
}

variable "ohio_subnet_azs" {
  description = "Availability zones of the Private VPC"
  type        = list(string)
}
variable "ohio_private_subnet_cidrs" {
  description = "CIDRs for the private subnets of the Private VPC"
  type        = list(string)
}


#### EC2 Instances ####
# Web Server
variable "web_server_details" {
  description = "EC2 instance configuration for the Web Server"
  type = object({
    ami  = string,
    type = string,
    key  = string,
    code = string,
  })
}
# MySQL Workbench
variable "mysql_workbench_details" {
  description = "EC2 instance configuration for the MySQL Workbench"
  type = object({
    ami  = string,
    type = string,
    key  = string,
  })
}


#### RDS Variables ####
variable "mysql_details" {
  description = "RDS instance configuration for the DataBase"
  type = object({
    engine         = string,
    engine_version = string,
    class          = string,
    storage_size   = number,
    user           = string,
    psswd          = string,
    db             = string,
  })
}
