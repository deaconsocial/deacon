resource "digitalocean_database_cluster" "deacon" {
  name                 = "${local.prefix}-postgres"
  engine               = "pg"
  version              = "14"
  size                 = "db-s-1vcpu-1gb"
  region               = var.region
  node_count           = 1
  private_network_uuid = digitalocean_vpc.deacon.id
}

resource "digitalocean_database_firewall" "example-fw" {
  cluster_id = digitalocean_database_cluster.deacon.id

  dynamic "rule" {
    for_each = digitalocean_droplet.app
    content {
      type  = "droplet"
      value = rule.value.id
    }
  }
}

resource "digitalocean_database_db" "deacon" {
  cluster_id = digitalocean_database_cluster.deacon.id
  name       = local.prefix
}

resource "digitalocean_database_connection_pool" "deacon" {
  cluster_id = digitalocean_database_cluster.deacon.id
  name       = "${local.prefix}-pool"
  mode       = "session"
  size       = 11
  db_name    = digitalocean_database_db.deacon.name
  user       = "doadmin"
}

data "digitalocean_database_ca" "deacon" {
  cluster_id = digitalocean_database_cluster.deacon.id
}
