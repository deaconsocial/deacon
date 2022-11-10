output "app_ips" {
  value = [for app in digitalocean_droplet.app : app.ipv4_address]
}

output "db_ca" {
  value = data.digitalocean_database_ca.deacon.certificate
}
