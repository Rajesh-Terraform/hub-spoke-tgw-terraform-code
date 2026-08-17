terraform {
  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55"
    }
  }
}

provider "aws" {
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

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "hub"
  region = var.region
}