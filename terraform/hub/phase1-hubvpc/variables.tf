variable "hub_vpc_id" {
  description = "Hub VPC ID"
  type        = string
}

variable "tgw_name" {
  description = "Transit Gateway name"
  type        = string
  default     = "hub-tgw"
}

variable "amazon_side_asn" {
  description = "Transit Gateway Amazon side ASN"
  type        = number
  default     = 64512
}

variable "spoke_account_id" {
  description = "Spoke AWS account ID"
  type        = string
}