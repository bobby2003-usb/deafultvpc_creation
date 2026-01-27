# VPC (MANDATORY: cidr_block)
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
}

# Public Subnet (MANDATORY: vpc_id, cidr_block, availability_zone)
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
}

# Internet Gateway (MANDATORY: vpc_id)
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# Route Table (MANDATORY: vpc_id + route)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

# Route Table Association (MANDATORY: subnet_id, route_table_id)
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
