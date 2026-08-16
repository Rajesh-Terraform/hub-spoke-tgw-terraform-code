terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "spoke"
  region = "ap-south-1"

  assume_role {
    role_arn = "arn:aws:iam::434097521299:role/testingdummy"
  }
}


# HUB VPC
data "aws_vpc" "hub" {
  provider = aws

  filter {
    name   = "tag:Name"
    values = ["hub-vpc"]
  }
}


# HUB PRIVATE SUBNETS
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


# SPOKE VPC
data "aws_vpc" "spoke" {
  provider = aws.spoke

  filter {
    name   = "tag:Name"
    values = ["spoke-vpc"]
  }
}


# SPOKE PRIVATE SUBNETS
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