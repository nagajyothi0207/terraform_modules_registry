data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  id = aws_vpc.default.id
}


# The attribute `${data.aws_caller_identity.current.account_id}` will be current account number.
data "aws_caller_identity" "current" {}

# The attribute `${data.aws_region.current.name}` will be current region
data "aws_region" "current" {}

# The attribute `${data.aws_partition.current.partition}` will be current partition
data "aws_partition" "current" {}