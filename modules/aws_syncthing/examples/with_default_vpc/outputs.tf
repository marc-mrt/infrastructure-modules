output "syncthing_hello" {
  value = "Syncthing running on IP: ${module.syncthing.instance_public_ip}"
}
