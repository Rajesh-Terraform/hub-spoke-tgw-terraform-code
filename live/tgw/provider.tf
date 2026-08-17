terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55"
    }
  }
}

# HUB ACCOUNT
provider "aws" {
  alias  = "hub"
  region = var.region

  default_tags {
    tags = {
      Project     = "enterprise-networking-lab"
      Environment = "practice"
      Account     = "hub"
      ManagedBy   = "terraform"
    }
  }
}

# SPOKE ACCOUNT
provider "aws" {
  alias  = "spoke"
  region = var.region

  assume_role {
    role_arn =  "arn:aws:iam::434097521299:role/testingdummy"
  }

  default_tags {
    tags = {
      Project     = "enterprise-networking-lab"
      Environment = "practice"
      Account     = "spoke"
      ManagedBy   = "terraform"
    }
  }
}