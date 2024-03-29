resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = merge(var.tags, { Name = "${var.env}-vpc" })
}

module "subnets" {
  source = "./subnets"

  for_each   = var.subnets
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value["cidr_blocks"]
  name       = each.value["name"]
  azs        = each.value["azs"]

  tags = var.tags
  env  = var.env

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, { Name = "${var.env}-igw" })
}

resource "aws_eip" "ngw" {
  count = length(var.subnets["public"].cidr_blocks)
  vpc   = true

  tags = merge(var.tags, { Name = "${var.env}-ngw" })
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.subnets["public"].cidr_blocks)
  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = module.subnets["public"].subnet_ids[count.index]

  tags = merge(var.tags, { Name = "${var.env}-ngw" })
}

resource "aws_route" "igw" {
  count                  = length(module.subnets["public"].route_table_ids)
  route_table_id         = module.subnets["public"].route_table_ids[count.index]
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route" "ngw" {
  count                  = length(local.all_private_route_table_ids)
  route_table_id         = local.all_private_route_table_ids[count.index]
  nat_gateway_id         = element(aws_nat_gateway.ngw.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"

}