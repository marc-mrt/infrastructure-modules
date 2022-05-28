output "instance_public_ip" {
  value       = aws_instance.syncthing.public_ip
  description = "The instance's public IP address"
}
