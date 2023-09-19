resource "aws_subnet" "subnets" {
  count             = length(var.cidr_block)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr_block[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, { Name = "${var.name}-${var.env}-subnet-${count.index+1}" })
}

resource "aws_route_table" "route" {
  count  = length(var.cidr_block)
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.name}-${var.env}-route-${count.index+1}" })
}

resource "aws_route_table_association" "association" {
  count          = length(var.cidr_block)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route[count.index].id
}

