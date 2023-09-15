resource "aws_subnet" "subnets" {
  count      = length(var.cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block[count.index]
  availability_zone = var.azs[count.index]
  tags       = merge(var.tags, { Name = "${var.name}-${var.env}-subnet-${count.index+1}" })
}