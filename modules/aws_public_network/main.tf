resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cdir_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
}

resource "aws_subnet" "public" {
  availability_zone       = var.aws_availability_zone
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cdir_block
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group_rule" "all_outbound" {
  type = "egress"

  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.main.id
}
