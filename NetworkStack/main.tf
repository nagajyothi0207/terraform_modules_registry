# VPC
resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "vpc"
  }
}


resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = values(aws_subnet.public_subnet)[0].id
  connectivity_type = "public"
  tags = {
    Name = "NATGW"
  }
}

#Internet gateway
resource "aws_internet_gateway" "default_igw" {
  vpc_id = aws_vpc.default.id
  tags = {
    "Name"        = "igw"
  }
}



resource "aws_vpc_endpoint" "endpoints" {
  for_each          = local.endpoints
  vpc_id            = data.aws_vpc.default.id
  subnet_ids        = [values(aws_subnet.private_subnet)[0].id]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true
  service_name      = "com.amazonaws.${local.region}.${each.value.name}"
  # Add a security group to the VPC endpoint
  security_group_ids = [aws_security_group.private_security_group.id]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = data.aws_vpc.default.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = ["${aws_route_table.private_rt.id}"]

  tags = {
    Name = "my-s3-endpoint"
  }
}