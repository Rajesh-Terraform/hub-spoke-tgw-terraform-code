output "spoke_vpc_id" {
  value = module.spoke_vpc.vpc_id
}

output "spoke_vpc_cidr" {
  value = module.spoke_vpc.vpc_cidr
}

output "spoke_private_subnet_ids" {
  value = module.spoke_vpc.private_subnet_ids
}

output "spoke_private_route_table_ids" {
  value = module.spoke_vpc.private_route_table_ids
}