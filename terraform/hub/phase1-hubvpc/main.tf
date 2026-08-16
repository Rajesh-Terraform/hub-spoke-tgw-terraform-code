data "aws_vpc" "hub" {
  id = var.hub_vpc_id
}

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

  name             = var.tgw_name
  amazon_side_asn  = var.amazon_side_asn
  spoke_account_id = var.spoke_account_id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  vpc_id = data.aws_vpc.hub.id

  subnet_ids = [
    data.aws_subnets.hub_private.ids[0],
    data.aws_subnets.hub_private.ids[1]
  ]

  transit_gateway_id = module.transit_gateway.transit_gateway_id

  tags = {
    Name = "${var.tgw_name}-hub-attachment"
  }
}