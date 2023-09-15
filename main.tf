resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags  = merge(var.tags,{Name = "${var.env}-vpc"})
}

module "subnets" {
  for_each = var.subnets
  source = "./subnets"
  vpc_id = aws_vpc.vpc.id
  cidr_block = each.value["cidr_block"]
  name = each.value["name"]
  tags = var.tags
  env = var.env
}