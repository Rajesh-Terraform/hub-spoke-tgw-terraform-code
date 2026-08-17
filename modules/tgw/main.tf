resource "aws_ec2_transit_gateway" "main" {
  provider = aws.hub

  description = var.name

  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}


# HUB VPC ATTACHMENT
resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  provider = aws.hub

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.hub_vpc_id
  subnet_ids         = var.hub_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-hub-attachment"
    }
  )
}


# SPOKE VPC ATTACHMENT
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  provider = aws.spoke

  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = var.spoke_vpc_id
  subnet_ids         = var.spoke_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-spoke-attachment"
    }
  )

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.hub
  ]
}