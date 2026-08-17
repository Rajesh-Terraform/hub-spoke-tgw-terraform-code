variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "create_igw" {
  type    = bool
  default = true
}

variable "create_public_subnets" {
  type    = bool
  default = true
}

variable "create_nat_gateways" {
  type    = bool
  default = true
}
