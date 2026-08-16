resource "aws_ec2_transit_gateway" "this" {
  description = var.name

  amazon_side_asn = var.amazon_side_asn

  default_route_table_association = "disable"
  default_route_table_propagation  = "disable"

  dns_support = "enable"

  tags = {
    Name = var.name
  }
}

resource "aws_ec2_transit_gateway_route_table" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.name}-hub-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id

  tags = {
    Name = "${var.name}-spoke-rt"
  }
}

resource "aws_ram_resource_share" "tgw" {
  name = "${var.name}-share"

  allow_external_principals = true

  tags = {
    Name = "${var.name}-ram-share"
  }
}

resource "aws_ram_resource_association" "tgw" {
  resource_share_arn = aws_ram_resource_share.tgw.arn
  resource_arn       = aws_ec2_transit_gateway.this.arn
}

resource "aws_ram_principal_association" "spoke" {
  resource_share_arn = aws_ram_resource_share.tgw.arn
  principal          = var.spoke_account_id
}

module "transit_gateway" {
  source = "./modules/transit-gateway"

  name              = var.tgw_name
  amazon_side_asn   = var.amazon_side_asn
  spoke_account_id  = var.spoke_account_id
}
