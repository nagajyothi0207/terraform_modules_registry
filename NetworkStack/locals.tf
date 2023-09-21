# Set as [local values](https://www.terraform.io/docs/configuration/locals.html)
locals {
  account_id    = data.aws_caller_identity.current.account_id
  region        = data.aws_region.current.name
  partition     = data.aws_partition.current.partition
  az_names = data.aws_availability_zones.available.names
  endpoints = {
    "endpoint-ssm" = {
      name = "ssm"
    },
    "endpoint-ssmm-essages" = {
      name = "ssmmessages"
    },
    "endpoint-ec2-messages" = {
      name = "ec2messages"
    }
  }
}