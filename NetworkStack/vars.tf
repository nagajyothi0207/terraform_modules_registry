variable "default_vpc_id" {
  default = ""
}

variable "vpc_cidr_block" {
  default = ""
}

variable "public_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for public subnets"
  default = {
    "ap-southeast-1a" = 1
    "ap-southeast-1b" = 2
    "ap-southeast-1c" = 3
  }
}
 
variable "private_subnet_numbers" {
  type = map(number)
  description = "Map of AZ to a number that should be used for private subnets"
  default = {
    "ap-southeast-1a" = 4
    "ap-southeast-1b" = 5
    "ap-southeast-1c" = 6
  }
}

variable "my_public_ip_address" {
  default = ""
}

variable "create_ssm_endpoints" {
  description = "If set to true, it will create vm"
  type   = bool
  default = true

}

