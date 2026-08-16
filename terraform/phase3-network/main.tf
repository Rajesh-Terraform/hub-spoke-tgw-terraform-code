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