terraform {
  required_version = "~> 1.1.5"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_project" "deacon" {
  name        = "deacon"
  description = "Project for the deacon.social Mastodon instance."
  purpose     = "Mastodon Instance"
  environment = "Production"

  resources = setunion(
    [
      for droplet in digitalocean_droplet.app : droplet.urn
    ],
    [
      digitalocean_domain.deacon.urn,
      digitalocean_loadbalancer.deacon-public.urn,
      digitalocean_database_cluster.deacon.urn,
    ],
  )
}

resource "digitalocean_ssh_key" "authorized_user" {
  for_each = var.ssh_keys

  name       = "${local.prefix}-${each.value}"
  public_key = file("../ssh/${each.value}")
}

