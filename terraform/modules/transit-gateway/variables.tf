variable "name" {
  type = string
}

variable "amazon_side_asn" {
  type    = number
  default = 64512
}

variable "spoke_account_id" {
  type = string
}


variable "name" {
  description = "Transit Gateway name"
  type        = string
}

variable "amazon_side_asn" {
  description = "Amazon side ASN"
  type        = number
  default     = 64512
}

variable "spoke_account_id" {
  description = "AWS spoke account ID"
  type        = string
}