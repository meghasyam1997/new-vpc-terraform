output "subnets" {
  value = module.subnets
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}