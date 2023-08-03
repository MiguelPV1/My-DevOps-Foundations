#### VPC PEERING ####
resource "aws_vpc_peering_connection" "vpc_peering" {
  provider = aws.public

  vpc_id      = aws_vpc.virginia_vpc.id
  peer_vpc_id = aws_vpc.ohio_vpc.id
  peer_region = var.app_region[1]
  auto_accept = false

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-vpc-peering"
    Owner = var.owner
    App   = var.app
  }
}

resource "aws_vpc_peering_connection_accepter" "vpc_peering_accepter" {
  provider = aws.private

  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
  auto_accept               = true

  tags = {
    Name  = "${var.app_env}-${var.app_id}-${var.app_region_name[0]}-vpc-peering-accepter"
    Owner = var.owner
    App   = var.app
  }
}

## Add Route Table for VPC Peering ##
resource "aws_route" "rt_peering_public" {
  provider = aws.public

  route_table_id = aws_route_table.virginia_public_rtb.id
  # destination_cidr_block = var.ohio_private_subnet_cidrs[0]
  destination_cidr_block    = var.vpc_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "rt_peering_private" {
  provider = aws.private

  route_table_id            = aws_vpc.ohio_vpc.main_route_table_id
  destination_cidr_block    = var.vpc_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Ref: https://awstip.com/aws-multi-region-vpc-peering-using-terraform-a0b8aabf084b
