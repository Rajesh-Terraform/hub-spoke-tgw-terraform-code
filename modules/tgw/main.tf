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

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws.hub

  vpc_id = data.aws_vpc.hub.id

  subnet_ids = [
    data.aws_subnets.hub_private.ids[0],
    data.aws_subnets.hub_private.ids[1]
  ]

  transit_gateway_id = aws_ec2_transit_gateway.this.id
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

