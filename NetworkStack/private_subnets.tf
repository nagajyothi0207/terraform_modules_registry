resource "aws_subnet" "private_subnet" {
  for_each = var.private_subnet_numbers
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, each.value)    #"172.31.${90+count.index}.0/27"
  availability_zone       = each.key
  map_public_ip_on_launch = false
  tags = {
    Name = "Private_Subnet_${each.key}"
  }
}


resource "aws_network_acl" "private_subnet_nacl" {
  vpc_id = data.aws_vpc.default.id
  subnet_ids = values(aws_subnet.private_subnet).*.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = values(aws_subnet.public_subnet)[0].cidr_block
    from_port  = 80
    to_port    = 80
  }

    ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = values(aws_subnet.public_subnet)[1].cidr_block
    from_port  = 80
    to_port    = 80
  }
    ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = values(aws_subnet.private_subnet)[2].cidr_block
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 1024
    to_port    = 65535
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 1000
    action     = "allow"
    cidr_block = values(aws_subnet.public_subnet)[0].cidr_block
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = values(aws_subnet.public_subnet)[0].cidr_block
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 1100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 1100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name = "Private_NACL"
  }
}





resource "aws_route_table" "private_rt" {
  vpc_id = data.aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.natgw.id
  }
  tags = {
    Name = "Private_RT"
  }
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = values(aws_subnet.private_subnet)[0].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = values(aws_subnet.private_subnet)[1].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = values(aws_subnet.private_subnet)[2].id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "private_security_group" {
  name        = "Private_SG_allow_local"
  description = "to allow traffic from private ips"
  vpc_id      = data.aws_vpc.default.id

#Bastion host to connect to the EC2 instances running on Private Subnets
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [values(aws_subnet.public_subnet)[0].cidr_block]
  }

# ALB Traffic from public Subnets
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [values(aws_subnet.public_subnet)[0].cidr_block, values(aws_subnet.public_subnet)[1].cidr_block, values(aws_subnet.public_subnet)[2].cidr_block]
  }

  # VPC Endpoints are deployed on Private Subnets, so, it required to listern internal traffic on 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  # Internet Access for Package download and installation of softwares like nginx/apache
    egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }
}
