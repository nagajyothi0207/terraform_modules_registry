resource "aws_subnet" "public_subnet" {
  for_each = var.public_subnet_numbers
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name = "Public_Subnet_${each.key}"
  }
}


resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id = data.aws_vpc.default.id
  subnet_ids =  values(aws_subnet.public_subnet).*.id
# For NATGW Access from VPC Cidr
ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = data.aws_vpc.default.cidr_block
    from_port  = 1024
    to_port    = 65535
  }

# Communication to ALB on Nginx Port
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = values(aws_subnet.private_subnet)[0].cidr_block #aws_subnet.private_subnet[0].cidr_block
    from_port  = 80
    to_port    = 80
  }
egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = values(aws_subnet.private_subnet)[1].cidr_block
    from_port  = 80
    to_port    = 80
  }
egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = values(aws_subnet.private_subnet)[2].cidr_block
    from_port  = 80
    to_port    = 80
  }

# Optional for SSH Traffic to private Servers (Optioal - Only if Bastion Server deployment needed)

ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.my_public_ip_address
    from_port  = 22
    to_port    = 22
  }

# Internet Access to the ALB for Ngnix page
ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 500
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }


  # Internet out for NATGW (Optional - Only required if NATGW deployment is needed)
    egress {
    protocol   = "tcp"
    rule_no    = 1400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
    ingress {
    protocol   = "tcp"
    rule_no    = 1400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "Public NACL"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default_igw.id
  }

  tags = {
    Name = "public_RT"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = values(aws_subnet.public_subnet)[0].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = values(aws_subnet.public_subnet)[1].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = values(aws_subnet.public_subnet)[2].id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "Public_SG" {
  name        = "Public_SG_allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = data.aws_vpc.default.id

# If Bastion Server deployment is `true`, this rule allows only from a trusted source to connect EC2 using SSH
  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip_address]
  }
# Internet Users to connect Public Load Balancer 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# to send the Nginx/Apache traffic to Private Servers/EC2
    egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.private_security_group.id]
  }

# for any Internet Traffic from Bastion Host
    egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public_SG_allow_http"
  }
}

