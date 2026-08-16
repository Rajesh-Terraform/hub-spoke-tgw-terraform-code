output "hub_vpc_id" {
  value = module.hub_vpc.vpc_id
}

output "hub_vpc_cidr" {
  value = module.hub_vpc.vpc_cidr
}

output "hub_public_subnet_ids" {
  value = module.hub_vpc.public_subnet_ids
}

output "hub_private_subnet_ids" {
  value = module.hub_vpc.private_subnet_ids
}

output "hub_private_route_table_ids" {
  value = module.hub_vpc.private_route_table_ids
}