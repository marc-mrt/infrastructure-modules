data "http" "host_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  host_cdir_block = "${chomp(data.http.host_ip.body)}/32"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "miniflux" {
  public_key = tls_private_key.example.public_key_openssh
}

module "miniflux" {
  source = "../../"

  project     = "miniflux"
  environment = "example"
  owner       = "GitHub"

  domain = "miniflux.example.com"

  aws_region                = "eu-central-1"
  aws_availability_zone     = "eu-central-1a"
  aws_snapshot_storage_tier = "archive"

  ssh_cdir_blocks = [host_cdir_block]
  ssh_key_name    = aws_key_pair.miniflux.key_name
}
