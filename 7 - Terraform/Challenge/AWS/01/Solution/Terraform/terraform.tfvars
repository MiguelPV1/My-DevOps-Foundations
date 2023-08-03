#### App variables ####
app_env         = "devops"
app_id          = "tfch01"
app_region      = ["us-east-1", "us-east-2"]
app_region_name = ["virginia", "ohio"]
owner           = "Tony"
app             = "Tf-AWS-Challenge01"
my_ip           = "0.0.0.0/0"
virginia_pem    = "../devops-tfch01-virginia.pem"


#### VPCs variables ####
vpc_cidrs                    = ["192.168.0.0/16", "10.0.0.0/16"]
virginia_subnet_azs          = ["us-east-1a", "us-east-1b"]
virginia_public_subnet_cidrs = ["192.168.1.0/24", "192.168.2.0/24"]
virginia_nic_ips             = ["192.168.1.100", "192.168.2.100"]

ohio_subnet_azs           = ["us-east-2a", "us-east-2b"]
ohio_private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]


#### EC2 Instances ####
web_server_details = {
  ami : "ami-053b0d53c279acc90",
  type : "t2.micro",
  key : "devops-tfch01-virginia",
  code : "../07_aws-ch01-deploy.sh",
}
mysql_workbench_details = {
  ami : "ami-0f769c109ff4a782d",
  type : "t2.micro",
  key : "devops-tfch01-virginia",
}


#### RDS Variables ####
mysql_details = {
  engine : "mysql",
  engine_version : "8.0.32",
  class : "db.t2.micro",
  storage_size : 10,
  user : "coffee",
  psswd : "12345678-Aa",
  db : "coffee",
}
