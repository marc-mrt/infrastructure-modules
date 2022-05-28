output "id" {
  value       = data.aws_ami.debian.id
  description = "The ID of the AMI"
}
