output "vpc_id" {
  value = module.spoke_vpc.vpc_id
}

output "vpc_cidr" {
  value = module.spoke_vpc.vpc_cidr
}

output "private_subnet_ids" {
  value = module.spoke_vpc.private_subnet_ids
}

output "private_route_table_ids" {
  value = module.spoke_vpc.private_route_table_ids
}