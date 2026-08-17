variable "name" {
  type = string
}

variable "spoke_account_id" {
  type = string
}

variable "hub_vpc_id" {
  type = string
}

variable "hub_vpc_cidr" {
  type = string
}

variable "hub_subnet_ids" {
  type = list(string)
}

variable "hub_public_route_table_id" {
  type = string
}

variable "hub_private_route_table_ids" {
  type = list(string)
}

variable "spoke_vpc_id" {
  type = string
}

variable "spoke_vpc_cidr" {
  type = string
}

variable "spoke_subnet_ids" {
  type = list(string)
}

variable "spoke_route_table_ids" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "hub_vpc_id" {
  description = "VPC ID of the hub VPC"
  type        = string
}