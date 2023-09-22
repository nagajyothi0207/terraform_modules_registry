# Module declaration from projects

```hcl
variable "myip" {
  description = "The public IP of your trusted network to access the Bastion Server"
  default     = ""
}
variable "vpc_cidr" {
  description = "cidr block for VPC creation, e.g 172.31.0.0/16"
  default     = ""
}

module "network_stack" {
  source               = "git::https://github.com/nagajyothi0207/terraform_modules_registry//Network_Stack?ref=aws_vpc_three_tier-v0.0.1"
  vpc_cidr_block       = var.vpc_cidr
  my_public_ip_address = var.myip # Your public IP address to allow SSH Access to the Bastion Host
}

output "vpc_id" {
  value = module.network_stack.vpc_id
}
output "public_subnets" {
  value = module.network_stack.public_subnets
}
output "private_subnets" {
  value = module.network_stack.private_subnets
}
output "private_subnet_ids" {
  value = module.network_stack.private_subnet_ids
}
output "public_subnet_ids" {
  value = module.network_stack.public_subnet_ids
}

output "public_subnet_ids_1" {
  value = module.network_stack.public_subnet_ids[0]
}

```

For more examples, please refer to the examples directory.

## Inputs to this module
1. myip
2. VPC CIDR 


## Outputs

## Dependencies
List any dependencies your module requires, such as specific Terraform providers.