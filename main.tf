resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Name = "${var.env}-vpc" })
}

module "subnets" {
  for_each   = var.subnets
  source     = "./subnets"
  vpc_id     = aws_vpc.vpc.id
  cidr_block = each.value["cidr_block"]
  name       = each.value["name"]
  azs        = each.value["azs"]
  tags       = var.tags
  env        = var.env
}

resource "aws_internet_gateway" "igw" {
  #  count = length(lookup(lookup(var.subnets,"public","null" ),cidr_block,0))
  vpc_id = aws_vpc.vpc.id
  tags   = merge(var.tags, { Name = "${var.env}-igw" })
}

resource "aws_eip" "eip_ngw" {
  count = length(var.subnets["public"].cidr_block)
  vpc   = true
  tags  = merge(var.tags, { Name = "${var.env}-eip_ngw-${count.index+1}" })
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.subnets["public"].cidr_block)
  allocation_id = aws_eip.eip_ngw[count.index].id
  subnet_id     = module.subnets["public"].subnets_id[count.index]

  tags = merge(var.tags, { Name = "${var.env}-ngw-${count.index+1}" })
}

output "subnets" {
  value = module.subnets
}