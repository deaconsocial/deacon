resource "digitalocean_spaces_bucket" "uploads" {
  name   = "uploads-deacon-social"
  region = var.region

  acl = "public-read"

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["https://deacon.social"]
    max_age_seconds = 600
  }

  versioning {
    enabled = false
  }
}

resource "digitalocean_certificate" "cdn" {
  name = "${local.prefix}-cdn"
  type = "lets_encrypt"
  domains = [
    "uploads.${digitalocean_domain.deacon.name}"
  ]
}

resource "digitalocean_cdn" "uploads" {
  origin           = digitalocean_spaces_bucket.uploads.bucket_domain_name
  custom_domain    = "uploads.${digitalocean_domain.deacon.name}"
  certificate_name = digitalocean_certificate.cdn.name
}
