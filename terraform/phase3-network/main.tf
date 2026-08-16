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

# =========================================================
# FIND EXISTING HUB VPC
# =========================================================

data "aws_vpc" "hub" {
  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}

# =========================================================
# FIND EXISTING HUB PRIVATE SUBNETS
# =========================================================

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

# =========================================================
# CREATE TRANSIT GATEWAY
# =========================================================

resource "aws_ec2_transit_gateway" "main" {
  description = "Hub-Spoke Transit Gateway"

  tags = {
    Name = "hub-spoke-tgw"
  }
}

# =========================================================
# ATTACH HUB VPC TO TRANSIT GATEWAY
# =========================================================

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