resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags  = merge(var.tags,{Name = "${var.env}-vpc"})
}