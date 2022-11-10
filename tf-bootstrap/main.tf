terraform {
  required_version = "~> 1.1.5"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    endpoint                    = "https://sfo3.digitaloceanspaces.com"
    region                      = "us-east-1"
    bucket                      = "tf-state.deacon.social"
    key                         = "bootstrap.tfstate"
  }
}

resource "digitalocean_spaces_bucket" "state-backend" {
  name   = "tf-state.deacon.social"
  region = var.region

  acl = "private"
  versioning {
    enabled = true
  }
}
