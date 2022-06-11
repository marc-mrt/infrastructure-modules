output "instance_id" {
  value       = aws_instance.miniflux.id
  description = "The instance ID"
}

output "instance_public_ip" {
  value       = aws_instance.miniflux.public_ip
  description = "The instance's public IP address"
}
