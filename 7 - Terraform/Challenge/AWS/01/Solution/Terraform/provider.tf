provider "aws" {
  # access_key = var.access_key
  # secret_key = var.secret_key
  profile = "DevOps-Challenges"
  region  = var.app_region[0]
  alias   = "public"
}
provider "aws" {
  # access_key = var.access_key
  # secret_key = var.secret_key
  profile = "DevOps-Challenges"
  region  = var.app_region[1]
  alias   = "private"
}


# -> TERRAFROM CRASH COURSE
# https://www.youtube.com/watch?v=SLB_c_ayRMo&ab_channel=freeCodeCamp.org


# -> CREATE VPC
# https://spacelift.io/blog/terraform-aws-vpc
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest


# -> VPC IN TWO REGINS?
# https://www.reddit.com/r/Terraform/comments/10y3op8/how_to_create_aws_resources_in_different_regions/

# https://stackoverflow.com/questions/63675838/terrraform-create-aws-vpc-in-different-regions-based-on-region-input-variable
# https://stackoverflow.com/questions/51619602/terraform-lookup-aws-region
# https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/104


# -> VPC PEERING
# https://awstip.com/aws-multi-region-vpc-peering-using-terraform-a0b8aabf084b
# https://medium.com/tensult/vpc-peering-using-terraform-105d554ed04d
# https://dev.classmethod.jp/articles/how-to-use-terraform-to-create-vpc-peering-connections/

# https://registry.terraform.io/modules/grem11n/vpc-peering/aws/latest/examples/single-account-multi-region


# -> CREATE KEY-PAIR
# https://letmetechyou.com/create-an-aws-key-pair-using-terraform/

# -> CREATE RDS
# https://medium.com/strategio/using-terraform-to-create-aws-vpc-ec2-and-rds-instances-c7f3aa416133
