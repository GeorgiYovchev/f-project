resource "hcloud_server" "the-node" {
  name        = var.name
  image       = var.image
  server_type = var.server_type
  location    = var.location
  ssh_keys    = [data.hcloud_ssh_key.ssh_key.id]
}

output "server_ip" {
  value = hcloud_server.the-node.ipv4_address
}