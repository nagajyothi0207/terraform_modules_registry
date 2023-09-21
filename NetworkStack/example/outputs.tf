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
