resource "aws_default_vpc" "default" {
}

resource "aws_default_subnet" "default" {
  availability_zone = "eu-central-1a"
}

resource "aws_security_group" "default" {
  vpc_id = aws_default_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    description      = "Allow all outbound"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

module "miniflux" {
  source = "../../"

  project     = "miniflux"
  environment = "example"
  owner       = "GitHub"

  domain = "miniflux.example.com"

  aws_region            = "eu-central-1"
  aws_availability_zone = "eu-central-1a"

  username = "admin"
  password = "test12345"

  db_username = "db_admin"
  db_password = "db_test12345"

  security_group_id = aws_security_group.default.id
  subnet_id         = aws_default_subnet.default.id
}
