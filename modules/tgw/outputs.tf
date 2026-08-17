output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.main.id
}

output "hub_vpc_id" {
  value = var.hub_vpc_id
}

output "spoke_vpc_id" {
  value = var.spoke_vpc_id
}

output "hub_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub.id
}

output "spoke_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.spoke.id
}




