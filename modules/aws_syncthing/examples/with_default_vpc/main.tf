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

module "syncthing" {
  source = "../../"

  project     = "example"
  environment = "example"
  owner       = "GitHub"

  domain = "syncthing.example.com"

  aws_region            = "eu-central-1"
  aws_instance_type     = "t2.nano"
  aws_availability_zone = "eu-central-1a"

  secrets_path = "example/example"
  instance_parameters = [
    {
      name : "syncthing/gui/username",
      value : "admin",
    },
    {
      name : "syncthing/gui/password",
      value : "test",
    },
    {
      name : "syncthing/device/name",
      value : "AWS EC2",
    },
    {
      name : "syncthing/defaults/folder/path",
      value : "/var/syncthing/",
    }
  ]

  security_group_id = aws_security_group.default.id
  subnet_id         = aws_default_subnet.default.id
}
