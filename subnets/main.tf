resource "aws_subnet" "main" {
  for_each          = var.subnets
  vpc_id            = var.vpc_id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["az"]

  tags = {
    Name = each.key
  }
}

resource "aws_route_table" "main" {
  vpc_id = var.vpc_id
  for_each = var.subnets

  tags = {
    Name = each.key
  }
}




