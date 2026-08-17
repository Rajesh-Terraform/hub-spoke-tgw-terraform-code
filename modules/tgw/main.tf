

data "aws_subnets" "hub_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}

module "transit_gateway" {
  source = "./modules/transit-gateway"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  vpc_id = data.aws_vpc.hub.id

  subnet_ids = [
    data.aws_subnets.hub_private.ids[0],
    data.aws_subnets.hub_private.ids[1]
  ]

  transit_gateway_id = module.transit_gateway.transit_gateway_id
}




# =========================================================
# TRANSIT GATEWAY
# =========================================================

resource "aws_ec2_transit_gateway" "this" {
  provider = aws.hub

  description = var.name

  amazon_side_asn = 64512

  auto_accept_shared_attachments = "disable"

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  dns_support = "enable"

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# =========================================================
# RAM SHARE
# =========================================================

resource "aws_ram_resource_share" "tgw" {
  provider = aws.hub

  name = "${var.name}-share"

  # This must be true if the accounts are not in
  # the same AWS Organization.
  allow_external_principals = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-ram-share"
    }
  )
}

resource "aws_ram_resource_association" "tgw" {
  provider = aws.hub

  resource_share_arn = aws_ram_resource_share.tgw.arn
  resource_arn       = aws_ec2_transit_gateway.this.arn
}

resource "aws_ram_principal_association" "spoke" {
  provider = aws.hub

  principal          = var.spoke_account_id
  resource_share_arn = aws_ram_resource_share.tgw.arn
}

# =========================================================
# HUB TGW ATTACHMENT
# =========================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws.hub

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.hub_vpc_id
  subnet_ids         = var.hub_subnet_ids

  dns_support = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-hub-attachment"
    }
  )
}

# =========================================================
# SPOKE ATTACHMENT
# =========================================================

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = var.spoke_vpc_id
  subnet_ids         = var.spoke_subnet_ids

  dns_support = "enable"

  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  depends_on = [
    aws_ram_principal_association.spoke
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-spoke-attachment"
    }
  )
}

# =========================================================
# HUB TGW ROUTE TABLE
# =========================================================

resource "aws_ec2_transit_gateway_route_table" "hub" {
  provider = aws.hub

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-hub-rt"
    }
  )
}

# =========================================================
# SPOKE TGW ROUTE TABLE
# =========================================================

resource "aws_ec2_transit_gateway_route_table" "spoke" {
  provider = aws.hub

  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-spoke-rt"
    }
  )
}

# =========================================================
# ASSOCIATIONS
# =========================================================

resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  provider = aws.hub

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
}

resource "aws_ec2_transit_gateway_route_table_association" "spoke" {
  provider = aws.hub

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spoke.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
}

# =========================================================
# HUB -> SPOKE
# =========================================================

resource "aws_ec2_transit_gateway_route" "hub_to_spoke" {
  provider = aws.hub

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub.id
  destination_cidr_block         = var.spoke_vpc_cidr

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}

# =========================================================
# SPOKE -> HUB
# =========================================================

resource "aws_ec2_transit_gateway_route" "spoke_to_hub" {
  provider = aws.hub

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spoke.id
  destination_cidr_block         = var.hub_vpc_cidr

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.hub.id
}

# =========================================================
# HUB VPC ROUTES -> TGW
# =========================================================

resource "aws_route" "hub_public_to_spoke" {
  provider = aws.hub

  route_table_id         = var.hub_public_route_table_id
  destination_cidr_block = var.spoke_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

resource "aws_route" "hub_private_to_spoke" {
  provider = aws.hub

  count = length(var.hub_private_route_table_ids)

  route_table_id         = var.hub_private_route_table_ids[count.index]
  destination_cidr_block = var.spoke_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

# =========================================================
# SPOKE VPC ROUTES -> TGW
# =========================================================

resource "aws_route" "spoke_to_hub" {
  provider = aws.spoke

  count = length(var.spoke_route_table_ids)

  route_table_id         = var.spoke_route_table_ids[count.index]
  destination_cidr_block = var.hub_vpc_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}



terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.hub,
        aws.spoke
      ]
    }
  }
}



terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"

      configuration_aliases = [
        aws.hub,
        aws.spoke
      ]
    }
  }
}

resource "aws_ec2_transit_gateway" "this" {
  
}