
module "network_stack" {
  source               = "git::https://github.com/nagajyothi0207/terraform_modules_registry//Network_Stack?ref=v0.0.1"
  vpc_cidr_block       = var.vpc_cidr
  my_public_ip_address = var.myip # Your public IP address to allow SSH Access to the Bastion Host
}

