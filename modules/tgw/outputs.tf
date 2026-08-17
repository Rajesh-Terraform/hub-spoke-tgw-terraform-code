output "transit_gateway_id" {
  description = "Transit Gateway ID"
  value       = aws_ec2_transit_gateway.main.id
}

output "hub_vpc_id" {
  description = "Hub VPC ID"
  value       = data.aws_vpc.hub.id
}

output "hub_private_subnet_ids" {
  description = "Hub private subnet IDs"
  value       = data.aws_subnets.hub_private.ids
}

output "hub_tgw_attachment_id" {
  description = "Hub Transit Gateway attachment ID"
  value       = aws_ec2_transit_gateway_vpc_attachment.hub.id
}




output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.this.id
}

output "hub_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub.id
}

output "spoke_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}

output "hub_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.hub.id
}

output "spoke_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.spoke.id
}

output "ram_share_arn" {
  value = aws_ram_resource_share.tgw.arn
}