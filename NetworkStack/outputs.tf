output "vpc_id" {
  value = aws_vpc.default.id
}
output "public_subnets" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.public_subnet :
    subnet.id => subnet.cidr_block
  }
}
 
output "private_subnets" {
  # Result is a map of subnet id to cidr block, e.g.
  # { "subnet_1234" => "10.0.1.0/4", ...}
  value = {
    for subnet in aws_subnet.private_subnet :
    subnet.id => subnet.cidr_block
  }
}

output "private_subnet_ids" {
  value = values(aws_subnet.private_subnet).*.id
}
output "public_subnet_ids" {
  value = values(aws_subnet.public_subnet).*.id
}

output "Public_SG" {
  value = aws_security_group.Public_SG[*].id
}
output "Private_SG" {
  value = aws_security_group.private_security_group[*].id
}
