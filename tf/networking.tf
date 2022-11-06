
resource "digitalocean_vpc" "deacon" {
  name     = "${local.prefix}-network"
  region   = var.region
  ip_range = "10.10.10.0/24"
}

resource "digitalocean_domain" "deacon" {
  name = local.domain
}

resource "digitalocean_record" "www" {
  domain = digitalocean_domain.deacon.id
  type   = "CNAME"
  name   = "www"
  value  = "@"
}

resource "digitalocean_certificate" "public-tls" {
  name = "${local.prefix}-tls"
  type = "lets_encrypt"
  domains = [
    digitalocean_domain.deacon.name
  ]
}

resource "digitalocean_loadbalancer" "deacon-public" {
  name   = "deacon-public"
  region = var.region

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 80
    target_protocol = "http"

    certificate_name = digitalocean_certificate.public-tls.name
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }

  droplet_ids = [
    for droplet in digitalocean_droplet.app : droplet.id
  ]
}
