module "ami" {
  source = "../aws_ami_debian"
}

# -------------------------------------------------------------------------------------------------------
# ---------------------------------------- SECRETS MANAGEMENT -------------------------------------------
# -------------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "secrets" {
  for_each = {
    for index, param in var.instance_parameters :
    param.name => param
  }

  name  = "/${var.secrets_path}/${each.value.name}"
  value = each.value.value
  type  = "SecureString"
}

# ---------------------------------------------------------------------------------------------
# ---------------------------------------- INSTANCE -------------------------------------------
# ---------------------------------------------------------------------------------------------
resource "aws_launch_template" "syncthing" {
  user_data = filebase64("${path.module}/.syncthing/user_data.sh")
}

resource "aws_instance" "syncthing" {
  ami = module.ami.id

  instance_type     = var.aws_instance_type
  availability_zone = var.aws_availability_zone

  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.syncthing.name

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  launch_template {
    id      = aws_launch_template.syncthing.id
    version = "$Latest"
  }

  depends_on = [aws_ssm_parameter.secrets]
}

resource "aws_iam_role" "syncthing" {
  name = var.domain
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  inline_policy {
    name = "EC2ReadOnly"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = ["ec2:Describe*"]
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_iam_instance_profile" "syncthing" {
  name = var.domain
  role = aws_iam_role.syncthing.name
}

# --------------------------------------------------------------------------------------------
# ---------------------------------------- NETWORK -------------------------------------------
# --------------------------------------------------------------------------------------------
resource "aws_security_group_rule" "gui" {
  type = "ingress"

  from_port        = 8384
  to_port          = 8384
  protocol         = "tcp"
  description      = "Syncthing GUI"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}

resource "aws_security_group_rule" "tcp_p2p" {
  type = "ingress"

  from_port        = 22000
  to_port          = 22000
  protocol         = "tcp"
  description      = "Syncthing P2P"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}

resource "aws_security_group_rule" "udp_p2p" {
  type = "ingress"

  from_port        = 22000
  to_port          = 22000
  protocol         = "udp"
  description      = "Syncthing P2P"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}

resource "aws_security_group_rule" "udp_p2p_alt" {
  type = "ingress"

  from_port        = 21027
  to_port          = 21027
  protocol         = "udp"
  description      = "Syncthing P2P"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = var.security_group_id
}
