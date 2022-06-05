output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The VPC's ID"
}

output "subnet_id" {
  value       = aws_subnet.public.id
  description = "The public subnet's ID"
}

output "security_group_id" {
  value       = aws_security_group.main.id
  description = "The VPS's security group ID"
}
