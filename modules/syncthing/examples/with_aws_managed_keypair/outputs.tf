output "syncthing_hello" {
  value = "Syncthing running on IP: ${module.syncthing.instance_public_ip}"
}

output "private_key_pem" {
  sensitive = true
  value     = tls_private_key.example.private_key_pem
}
