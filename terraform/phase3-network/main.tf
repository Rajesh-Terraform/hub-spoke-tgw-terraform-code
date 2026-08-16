terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --------------------------------------------------
# Find existing Hub VPC
# --------------------------------------------------

data "aws_vpc" "hub" {
  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}

# --------------------------------------------------
# Find existing Hub private subnets
# --------------------------------------------------

data "aws_subnets" "hub_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.hub.id]
  }

  filter {
    name   = "tag:Name"
    values = ["hub-private-*"]
  }
}

# --------------------------------------------------
# Transit Gateway
# --------------------------------------------------

resource "aws_ec2_transit_gateway" "main" {
  description = "Hub-Spoke Transit Gateway"

  tags = {
    Name = "hub-spoke-tgw"
  }
}

# --------------------------------------------------
# Hub VPC -> Transit Gateway attachment
# --------------------------------------------------

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  vpc_id = data.aws_vpc.hub.id

  subnet_ids = [
    data.aws_subnets.hub_private.ids[0],
    data.aws_subnets.hub_private.ids[1]
  ]

  tags = {
    Name = "hub-tgw-attachment"
  }
}