# Defining data sources to help local variables
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "main" {
  id = var.vpc_id
}

# Defining local variables to be used on the module
locals {
  account_id            = data.aws_caller_identity.current.account_id
  region_name           = data.aws_region.current.name
  vpc_cidr              = data.aws_vpc.main.cidr_block
  alb_sg_inbound_ports  = var.alb_sg_inbound_ports
  alb_sg_outbound_ports = var.alb_sg_outbound_ports
}
