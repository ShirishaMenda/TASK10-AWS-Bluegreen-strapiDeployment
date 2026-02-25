data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  # These are public subnets because default VPC subnets have map-public-ip-on-launch = true
}

data "aws_availability_zones" "available" {}

# -----------------------------
# Create PRIVATE SUBNETS
# -----------------------------

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = cidrsubnet(data.aws_vpc.default.cidr_block, 4, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

# -----------------------------
# NAT Gateway & EIP
# -----------------------------

resource "aws_eip" "nat" {
  tags = {
    Name = "${var.name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(data.aws_subnets.public.ids, 0) # place NAT in 1st public subnet

  tags = {
    Name = "${var.name}-nat"
  }
}

# -----------------------------
# Private Route Table
# -----------------------------

resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}