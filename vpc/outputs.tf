output "id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public
}

output "private_subnets" {
  value = aws_subnet.private
}

output "aws_eip_nat_public_ips" {
  value = aws_eip.nat.*.public_ip
}