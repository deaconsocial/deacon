resource "digitalocean_droplet" "app" {
  count = var.app_scale
  name  = "${local.prefix}-${count.index}"

  vpc_uuid = digitalocean_vpc.deacon.id
  image    = var.app_image
  region   = var.region
  size     = var.app_instance_size
  ssh_keys = [
    for key in digitalocean_ssh_key.authorized_user : key.id
  ]
  tags       = local.base_tags
  ipv6       = true
  monitoring = true
}

resource "digitalocean_firewall" "app" {
  name = "${local.prefix}-app-server"

  inbound_rule {
    protocol    = "tcp"
    port_range  = "all"
    source_tags = ["application:deacon"]
  }

  inbound_rule {
    protocol   = "tcp"
    port_range = "80"
    source_load_balancer_uids = [
      digitalocean_loadbalancer.deacon-public.id
    ]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  tags = ["application:deacon"]
}
