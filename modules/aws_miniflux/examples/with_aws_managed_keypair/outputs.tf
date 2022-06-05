output "hello" {
  value = "Miniflux running. (IP: ${module.miniflux.instance_public_ip})"
}

output "private_key_pem" {
  sensitive = true
  value     = tls_private_key.example.private_key_openssh
}
