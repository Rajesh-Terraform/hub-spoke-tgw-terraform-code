module "spoke_vpc" {
  source = "../../modules/spoke-vpc"

  name     = "spoke-vpc"
  vpc_cidr = "10.1.0.0/16"

  availability_zones = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  private_subnet_cidrs = [
    "10.1.0.0/24",
    "10.1.1.0/24"
  ]

  tags = {
    Phase = "phase-2"
  }
}