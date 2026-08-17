output "transit_gateway_id" {
  value = module.tgw.transit_gateway_id
}

output "hub_attachment_id" {
  value = module.tgw.hub_attachment_id
}

output "spoke_attachment_id" {
  value = module.tgw.spoke_attachment_id
}

output "hub_tgw_route_table_id" {
  value = module.tgw.hub_route_table_id
}

output "spoke_tgw_route_table_id" {
  value = module.tgw.spoke_route_table_id
}

output "ram_share_arn" {
  value = module.tgw.ram_share_arn
}