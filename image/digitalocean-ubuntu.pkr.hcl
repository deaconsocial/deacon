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
    ]
    script = "./provision/01-root.sh"
  }

  provisioner "file" {
    source      = "config/nginx.conf"
    destination = "/etc/nginx/sites-available/mastodon"
  }

  provisioner "shell" {
    script = "./provision/02-mastodon.sh"
    execute_command = "sudo -u mastodon sh -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "RUBY_VERSION=3.0.4",
      "MASTODON_VERSION=v4.1.0",
    ]
    script = "./provision/03-mastodon.sh"
    execute_command = "sudo -u mastodon bash -c '{{ .Vars }} {{ .Path }}'"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    script = "./provision/04-root.sh"
  }
}
