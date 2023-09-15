output "subnets_id" {
  value = aws_subnet.subnets.*.id
}