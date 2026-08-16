module "spoke_vpc" {
  source = "../../modules/vpc"

  vpc_name = "spoke-vpc"

  vpc_cidr = "10.1.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnet_cidrs = []

  private_subnet_cidrs = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]

  create_igw             = false
  create_public_subnets  = false
  create_nat_gateways    = false
}


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