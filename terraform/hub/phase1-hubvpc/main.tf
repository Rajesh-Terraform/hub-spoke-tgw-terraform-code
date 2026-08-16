module "hub_vpc" {
  source = "../../modules/vpc"

  vpc_name = "hub-vpc"

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]

  create_igw          = true
  create_public_subnets = true
  create_nat_gateways = true
}


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

