output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "hub_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.hub.id
}

output "spoke_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke.id
}

output "ram_share_arn" {
  value = aws_ram_resource_share.this.arn
}


output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "hub_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.hub.id
}

output "spoke_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke.id
}

output "ram_share_arn" {
  value = aws_ram_resource_share.this.arn
}