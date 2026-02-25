output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}