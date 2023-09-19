output "subnets_id" {
  value = aws_subnet.subnets.*.id
}

output "route_ids" {
  value = aws_route_table.route.*.id
}
