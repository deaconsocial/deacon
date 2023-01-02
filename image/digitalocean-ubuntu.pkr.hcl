packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

source "digitalocean" "mastodon" {
  /* api_token    = "YOUR API KEY" */
  image         = "ubuntu-22-04-x64"
  region        = "sfo3"
  size          = "s-2vcpu-4gb-amd"
  ssh_username  = "root"
  droplet_agent = true
  /* private_networking = true */
  tags = ["environment:build"]
  /* vpc_uuid           = "" */
}

build {
  name    = "mastodon-deacon"
  sources = ["source.digitalocean.mastodon"]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "RUBY_VERSION=3.0.4",
      "MASTODON_VERSION=v4.0.2",
    ]
    script = "./image/provision/01-root.sh"
  }

  provisioner "file" {
    source      = "config/nginx.conf"
    destination = "/etc/nginx/sites-available/mastodon"
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
}
