data "aws_ami" "terraform_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  id = var.default_vpc_id
}


# The attribute `${data.aws_caller_identity.current.account_id}` will be current account number.
data "aws_caller_identity" "current" {}

# The attribute `${data.aws_region.current.name}` will be current region
data "aws_region" "current" {}

# The attribute `${data.aws_partition.current.partition}` will be current partition
data "aws_partition" "current" {}

# Set as [local values](https://www.terraform.io/docs/configuration/locals.html)
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  partition  = data.aws_partition.current.partition
}