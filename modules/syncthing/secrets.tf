resource "aws_ssm_parameter" "secrets" {
  for_each = {
    for index, param in var.instance_parameters :
    param.name => param
  }

  name  = "/${var.secrets_path}/${each.value.name}"
  value = each.value.value
  type  = "SecureString"
}
