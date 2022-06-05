output "hello" {
  value = "Miniflux running. (IP: ${module.miniflux.instance_public_ip})"
}
