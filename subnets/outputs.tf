output "subnet_ids" {
  value = aws_subnet.subnets.*.id
}

output "subnet_cidrs" {
  value = aws_subnet.subnets.*.cidr_block
}

output "route_ids" {
  value = aws_route_table.route.*.id
}
