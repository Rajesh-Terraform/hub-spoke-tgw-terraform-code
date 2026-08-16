# ============================================================
# PHASE 3
# TRANSIT GATEWAY + RAM + HUB/SPOKE ATTACHMENTS
# ============================================================


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
# HUB VPC
# ACCOUNT: 647132523867
# ============================================================

data "aws_vpc" "hub" {
  provider = aws

  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}


# ============================================================
# HUB PRIVATE SUBNETS
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
# SPOKE VPC
# ACCOUNT: 434097521299
# ============================================================

data "aws_vpc" "spoke" {
  provider = aws.spoke

  filter {
    name   = "tag:Name"
    values = ["spoke-vpc"]
  }
}


# ============================================================
# SPOKE PRIVATE SUBNETS
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
# HUB TGW ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws

  vpc_id = data.aws_vpc.hub.id

  subnet_ids = data.aws_subnets.hub_private.ids

  transit_gateway_id = module.transit_gateway.transit_gateway_id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "hub-tgw-attachment"
  }
}


# ============================================================
# SPOKE TGW ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  vpc_id = data.aws_vpc.spoke.id

  subnet_ids = data.aws_subnets.spoke_private.ids

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

resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hub.id

  transit_gateway_route_table_id = module.transit_gateway.hub_route_table_id
}


# ============================================================
# SPOKE ATTACHMENT -> SPOKE TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table_association" "spoke" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spoke.id

  transit_gateway_route_table_id = module.transit_gateway.spoke_route_table_id
}


# ============================================================
# HUB TGW -> SPOKE
# ============================================================

resource "aws_ec2_transit_gateway_route" "hub_to_spoke" {
  transit_gateway_route_table_id = module.transit_gateway.hub_route_table_id

  destination_cidr_block = "10.1.0.0/16"

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}


# ============================================================
# SPOKE TGW -> HUB
# ============================================================

resource "aws_ec2_transit_gateway_route" "spoke_to_hub" {
  transit_gateway_route_table_id = module.transit_gateway.spoke_route_table_id

  destination_cidr_block = "10.0.0.0/16"

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hub.id
}