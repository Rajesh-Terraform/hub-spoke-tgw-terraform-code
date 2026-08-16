# ============================================================
# PHASE 3
# TRANSIT GATEWAY + RAM + CROSS ACCOUNT ATTACHMENTS
# ============================================================


# ============================================================
# 1. CREATE TRANSIT GATEWAY
# HUB ACCOUNT: 647132523867
# ============================================================

resource "aws_ec2_transit_gateway" "hub_spoke" {
  provider = aws

  description = "Hub Spoke Transit Gateway"

  amazon_side_asn = 64512

  default_route_table_association = "disable"
  default_route_table_propagation  = "disable"

  dns_support = "enable"

  tags = {
    Name = "hub-spoke-tgw"
  }
}


# ============================================================
# 2. CREATE HUB TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table" "hub" {
  provider = aws

  transit_gateway_id = aws_ec2_transit_gateway.hub_spoke.id

  tags = {
    Name = "hub-tgw-route-table"
  }
}


# ============================================================
# 3. CREATE SPOKE TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table" "spoke" {
  provider = aws

  transit_gateway_id = aws_ec2_transit_gateway.hub_spoke.id

  tags = {
    Name = "spoke-tgw-route-table"
  }
}


# ============================================================
# 4. FIND HUB VPC
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
# 5. FIND HUB PRIVATE SUBNETS
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
# 6. FIND SPOKE VPC
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
# 7. FIND SPOKE PRIVATE SUBNETS
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
# 8. RAM RESOURCE SHARE
# HUB ACCOUNT
# ============================================================

resource "aws_ram_resource_share" "tgw" {
  provider = aws

  name = "hub-spoke-tgw-share"

  allow_external_principals = true

  tags = {
    Name = "hub-spoke-tgw-share"
  }
}


# ============================================================
# 9. SHARE TGW THROUGH RAM
# ============================================================

resource "aws_ram_resource_association" "tgw" {
  provider = aws

  resource_share_arn = aws_ram_resource_share.tgw.arn

  resource_arn = aws_ec2_transit_gateway.hub_spoke.arn
}


# ============================================================
# 10. SHARE WITH SPOKE ACCOUNT
# ============================================================

resource "aws_ram_principal_association" "spoke" {
  provider = aws

  resource_share_arn = aws_ram_resource_share.tgw.arn

  principal = "434097521299"
}


# ============================================================
# 11. HUB VPC -> TGW ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws

  vpc_id = data.aws_vpc.hub.id

  subnet_ids = data.aws_subnets.hub_private.ids

  transit_gateway_id = aws_ec2_transit_gateway.hub_spoke.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "hub-tgw-attachment"
  }
}


# ============================================================
# 12. SPOKE VPC -> TGW ATTACHMENT
# ============================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  vpc_id = data.aws_vpc.spoke.id

  subnet_ids = data.aws_subnets.spoke_private.ids

  transit_gateway_id = aws_ec2_transit_gateway.hub_spoke.id

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation  = false

  tags = {
    Name = "spoke-tgw-attachment"
  }
}


# ============================================================
# 13. HUB ATTACHMENT -> HUB TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  provider = aws

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.hub.id

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.hub.id
}


# ============================================================
# 14. SPOKE ATTACHMENT -> SPOKE TGW ROUTE TABLE
# ============================================================

resource "aws_ec2_transit_gateway_route_table_association" "spoke" {
  provider = aws

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.spoke.id

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.spoke.id
}


# ============================================================
# 15. HUB TGW -> SPOKE
# ============================================================

resource "aws_ec2_transit_gateway_route" "hub_to_spoke" {
  provider = aws

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.hub.id

  destination_cidr_block = "10.1.0.0/16"

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.spoke.id
}


# ============================================================
# 16. SPOKE TGW -> HUB
# ============================================================

resource "aws_ec2_transit_gateway_route" "spoke_to_hub" {
  provider = aws

  transit_gateway_route_table_id =
    aws_ec2_transit_gateway_route_table.spoke.id

  destination_cidr_block = "10.0.0.0/16"

  transit_gateway_attachment_id =
    aws_ec2_transit_gateway_vpc_attachment.hub.id
}