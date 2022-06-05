# ---------------------------------------------------------------------------------------------
# ----------------------------------------- IGNITION ------------------------------------------
# ---------------------------------------------------------------------------------------------
locals {
  system_user         = "core"
  system_user_homedir = "/home/${local.system_user}"

  docker_compose_bin_path = "/usr/local/bin/docker-compose"

  miniflux_docker_compose_path = "${local.system_user_homedir}/docker-compose.yml"

  database_volume_path = "${local.system_user_homedir}/data"
}

data "ignition_file" "docker-compose" {
  path = local.miniflux_docker_compose_path

  content {
    content = templatefile(
      "${path.module}/templates/docker-compose.yml.tftpl",
      {
        # This value cannot change, c.f. https://miniflux.app/docs/installation.html#docker
        db_name = "miniflux",
        db_user = var.db_username,
        db_pw   = var.db_password,

        admin_user = var.username,
        admin_pw   = var.password,

        db_volume = local.database_volume_path
      }
    )
  }
}

data "ignition_systemd_unit" "miniflux-docker-compose" {
  name    = "miniflux.service"
  content = <<EOT
[Unit]
Description=Runs Miniflux via docker-compose
After=install-docker-compose.service
Requires=install-docker-compose.service

[Service]
RemainAfterExit=yes
ExecStartPre=/usr/bin/mkdir -p ${local.database_volume_path}
ExecStart=${local.docker_compose_bin_path} -f ${local.miniflux_docker_compose_path} up -d --no-recreate
ExecStop=${local.docker_compose_bin_path} -f ${local.miniflux_docker_compose_path} down

[Install]
WantedBy=multi-user.target
EOT
}

data "ignition_systemd_unit" "install-docker-compose" {
  name    = "install-docker-compose.service"
  content = <<EOT
[Unit]
Description=Install docker-compose
After=network-online.target
Requires=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/curl -o ${local.docker_compose_bin_path} -sL "https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64"
ExecStart=/usr/bin/chmod +x ${local.docker_compose_bin_path}

[Install]
WantedBy=multi-user.target
EOT
}

data "ignition_config" "miniflux" {
  files = [
    data.ignition_file.docker-compose.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.install-docker-compose.rendered,
    data.ignition_systemd_unit.miniflux-docker-compose.rendered,
  ]
}

# ---------------------------------------------------------------------------------------------
# ----------------------------------------- INSTANCE ------------------------------------------
# ---------------------------------------------------------------------------------------------
resource "aws_instance" "miniflux" {
  ami = "ami-057a5a4c8bb76983d" # CoreOS

  instance_type     = var.aws_instance_type
  availability_zone = var.aws_availability_zone

  key_name = var.ssh_key_name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  # Render ignition config to user_data to ensure miniflux will be up and running.
  user_data = data.ignition_config.miniflux.rendered
}

# --------------------------------------------------------------------------------------------
# ---------------------------------------- NETWORK -------------------------------------------
# --------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "http" {
  type = "ingress"

  from_port        = 80
  to_port          = 80
  protocol         = "tcp"
  description      = "HTTP"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}

resource "aws_security_group_rule" "https" {
  type = "ingress"

  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  description      = "HTTPS"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}
