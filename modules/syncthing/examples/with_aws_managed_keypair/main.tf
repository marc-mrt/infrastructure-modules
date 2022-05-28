data "http" "host_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  host_cdir_blocks = ["${chomp(data.http.host_ip.body)}/32"]
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  public_key = tls_private_key.example.public_key_openssh
}

module "syncthing" {
  source = "../../"

  project     = "example"
  environment = "example"
  owner       = "GitHub"

  domain      = "syncthing.example.com"
  volume_name = "/dev/sdh"

  aws_region                = "eu-central-1"
  aws_instance_type         = "t2.nano"
  aws_availability_zone     = "eu-central-1a"
  aws_snapshot_storage_tier = "archive"

  ssh_cdir_blocks = []
  ssh_public_key  = aws_key_pair.generated_key.public_key

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
      value : "/dev/sdh",
    }
  ]
}
