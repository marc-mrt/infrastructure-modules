resource "aws_vpc" "syncthing" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = false
  instance_tenancy     = "default"
}

resource "aws_subnet" "public" {
  availability_zone       = var.aws_availability_zone
  vpc_id                  = aws_vpc.syncthing.id
  cidr_block              = "10.10.101.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "syncthing" {
  vpc_id = aws_vpc.syncthing.id
}

resource "aws_route_table" "syncthing" {
  vpc_id = aws_vpc.syncthing.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.syncthing.id
  }
}

resource "aws_route_table_association" "syncthing" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.syncthing.id
}

resource "aws_security_group" "syncthing" {
  name   = var.domain
  vpc_id = aws_vpc.syncthing.id

  ingress {
    from_port   = 22
    to_port     = 22
    description = "SSH"
    protocol    = "tcp"
    cidr_blocks = var.ssh_cdir_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    description      = "Allow all outbound"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 8384
    to_port          = 8384
    protocol         = "tcp"
    description      = "Syncthing GUI"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    description      = "HTTP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    description      = "HTTPS"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22000
    to_port          = 22000
    protocol         = "tcp"
    description      = "Syncthing P2P"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22000
    to_port          = 22000
    protocol         = "udp"
    description      = "Syncthing P2P"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 21027
    to_port          = 21027
    protocol         = "udp"
    description      = "Syncthing P2P"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
