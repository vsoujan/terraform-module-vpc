resource "aws_vpc" "main" {
  cidr_block = var.cidr
}

module "subnets" {
  source   = "./subnets"
  for_each = var.subnets
  subnets  = each.value
  vpc_id   = aws_vpc.main.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway"
  }
}

resource "aws_route" "igw" {
  for_each                = lookup(lookup(module.subnets, "public" null), "route_table_ids", null)
  route_table_id          = each.value["id"]
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id

}

resource "aws_eip" "ngw" {
count        = length(local.public_subnet_id)
domain       = "vpc"
}

resource "aws_nat_gateway" "ngw" {

  count           = length(local.public_subnet_id)
  allocation_id   = element(aws_eip.ngw.*.id, count.index )
  subnet_id       = element(local.public_subnet_id, count.index )
}

resource "aws_route" "ngw" {
  count = length(local.private_routetable_id)
  route_table_id          = element(local.private_routetable_id, count.index )
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id              = element(aws_nat_gateway.ngw.*.id, count.index )

}

output "subnets" {
  value = module.subnets
}