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




