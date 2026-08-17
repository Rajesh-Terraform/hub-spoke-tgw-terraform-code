data "terraform_remote_state" "hub" {
  backend = "s3"

  config = {
    bucket = "my-company-terraform-state-647132523867"
    key    = "networking/hub/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "spoke" {
  backend = "s3"

  config = {
    bucket = "my-company-terraform-state-647132523867"
    key    = "networking/spoke/terraform.tfstate"
    region = var.region
  }
}

module "tgw" {
  source = "../../modules/tgw"

  providers = {
    aws.hub   = aws.hub
    aws.spoke = aws.spoke
  }

  name = "hub-tgw"

  spoke_account_id = var.spoke_account_id

  hub_vpc_id = data.terraform_remote_state.hub.outputs.vpc_id

  hub_vpc_cidr = data.terraform_remote_state.hub.outputs.vpc_cidr

  hub_subnet_ids = data.terraform_remote_state.hub.outputs.private_subnet_ids

  hub_public_route_table_id = data.terraform_remote_state.hub.outputs.public_route_table_id

  hub_private_route_table_ids = data.terraform_remote_state.hub.outputs.private_route_table_ids

  spoke_vpc_id = data.terraform_remote_state.spoke.outputs.vpc_id

  spoke_vpc_cidr = data.terraform_remote_state.spoke.outputs.vpc_cidr

  spoke_subnet_ids = data.terraform_remote_state.spoke.outputs.private_subnet_ids

  spoke_route_table_ids = data.terraform_remote_state.spoke.outputs.private_route_table_ids

  tags = {
    Phase = "phase-3"
  }
}