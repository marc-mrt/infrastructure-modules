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

  key_name             = aws_key_pair.syncthing.key_name
  iam_instance_profile = aws_iam_instance_profile.syncthing.name

  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.syncthing.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  launch_template {
    id      = aws_launch_template.syncthing.id
    version = "$Latest"
  }

  depends_on = [aws_internet_gateway.syncthing, aws_ssm_parameter.secrets]
}

resource "aws_key_pair" "syncthing" {
  public_key = var.ssh_public_key
}

# ---------------------------------------------------------------------------------------------
# ----------------------------------------- VOLUMES -------------------------------------------
# ---------------------------------------------------------------------------------------------
resource "aws_ebs_volume" "syncthing" {
  availability_zone = var.aws_availability_zone
  encrypted         = true
  size              = var.volume_size
}

resource "aws_ebs_snapshot" "syncthing" {
  volume_id    = aws_ebs_volume.syncthing.id
  storage_tier = var.aws_snapshot_storage_tier
}

resource "aws_volume_attachment" "syncthing" {
  device_name = var.volume_name
  volume_id   = aws_ebs_volume.syncthing.id
  instance_id = aws_instance.syncthing.id

  force_detach                   = false
  skip_destroy                   = false
  stop_instance_before_detaching = true
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
