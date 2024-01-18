resource "hcloud_server" "the-server" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.ssh_key.id]
}

output "server_ip" {
  value = hcloud_server.the-server.ipv4_address
}