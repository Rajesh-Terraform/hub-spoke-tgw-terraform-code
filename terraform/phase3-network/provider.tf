terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# HUB ACCOUNT
provider "aws" {
  region = "ap-south-1"
}

# SPOKE ACCOUNT
provider "aws" {
  alias  = "spoke"
  region = "ap-south-1"

  assume_role {
    role_arn = "arn:aws:iam::434097521299:role/testingdummy"
  }
}