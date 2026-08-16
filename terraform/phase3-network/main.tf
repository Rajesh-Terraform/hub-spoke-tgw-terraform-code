module "transit_gateway" {
  source = "../modules/transit-gateway"

  name = "hub-spoke-tgw"

  amazon_side_asn = 64512

  spoke_account_id = "434097521299"
}


data "aws_vpc" "hub" {
  provider = aws

  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}

data "aws_vpc" "spoke" {
  provider = aws.spoke

  filter {
    name   = "tag:Name"
    values = ["spoke-vpc"]
  }
}  


data "aws_subnets" "spoke_private" {
  provider = aws.spoke

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}


module "transit_gateway" {
  source = "../modules/transit-gateway"

  name = "hub-spoke-tgw"

  amazon_side_asn = 64512

  spoke_account_id = "434097521299"
}



# ============================================================
# TRANSIT GATEWAY MODULE
# ============================================================

module "transit_gateway" {
  source = "../modules/transit-gateway"

  name = "hub-spoke-tgw"

  amazon_side_asn = 64512

  spoke_account_id = "434097521299"
}


# ============================================================
# FIND HUB VPC
# ============================================================

data "aws_vpc" "hub" {
  provider = aws

  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}


# ============================================================
# FIND HUB PRIVATE SUBNETS
# ============================================================

data "aws_subnets" "hub_private" {
  provider = aws

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}


# ============================================================
# FIND SPOKE VPC
# ============================================================

data "aws_vpc" "spoke" {
  provider = aws.spoke

  filter {
    name   = "tag:Name"
    values = ["spoke-vpc"]
  }
}


# ============================================================
# FIND SPOKE PRIVATE SUBNETS
# ============================================================

data "aws_subnets" "spoke_private" {
  provider = aws.spoke

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.spoke.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}


# ============================================================
# HUB TGW VPC ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws

  vpc_id = data.aws_vpc.hub.id

  subnet_ids = [
    data.aws_subnets.hub_private.ids[0],
    data.aws_subnets.hub_private.ids[1]
  ]

  transit_gateway_id = module.transit_gateway.transit_gateway_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "hub-tgw-attachment"
  }
}


# ============================================================
# SPOKE TGW VPC ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  vpc_id = data.aws_vpc.spoke.id

  subnet_ids = [
    data.aws_subnets.spoke_private.ids[0],
    data.aws_subnets.spoke_private.ids[1]
  ]

  transit_gateway_id = module.transit_gateway.transit_gateway_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "spoke-tgw-attachment"
  }
}



# ============================================================
# HUB ATTACHMENT -> HUB TGW ROUTE TABLE
# ============================================================

