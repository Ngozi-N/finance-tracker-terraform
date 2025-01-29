resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "finance-tracker-vpc"
  }
}

# resource "aws_subnet" "public" {
#   count = length(var.public_subnets)

#   vpc_id            = aws_vpc.main.id
#   cidr_block        = var.public_subnets[count.index]
#   map_public_ip_on_launch = true
#   availability_zone = element(["eu-west-2a", "eu-west-2b"], count.index)

#   tags = {
#     Name = "finance-tracker-public-${count.index}"
#   }
# }

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(["eu-west-2a", "eu-west-2b"], count.index)

  tags = {
    Name = "finance-tracker-private-${count.index}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = { Name = "finance-tracker-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = { Name = "finance-tracker-public-rt" }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
