output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}

output "hub_tgw_route_table_id" {
  value = module.transit_gateway.hub_route_table_id
}

output "spoke_tgw_route_table_id" {
  value = module.transit_gateway.spoke_route_table_id
}

output "ram_share_arn" {
  value = module.transit_gateway.ram_share_arn
}

output "hub_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub.id
}

output "spoke_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}