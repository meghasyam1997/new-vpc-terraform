resource "aws_subnet" "main" {
  count      = length(var.cidr_block)
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block[count.index]

  tags = {
    Name = "${var.name}-${count.index+1}"
  }
}