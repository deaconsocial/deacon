## TODO: Add monitoring.

# resource "digitalocean_monitor_alert" "cpu_alert" {resource "digitalocean_monitor_alert" "cpu_alert" {
#   alerts {
#     email = ["sammy@digitalocean.com"]
#     slack {
#       channel   = "Production Alerts"
#       url       = "https://hooks.slack.com/services/T1234567/AAAAAAAA/ZZZZZZ"
#     }
#   }
#   window      = "5m"
#   type        = "v1/insights/droplet/cpu"
#   compare     = "GreaterThan"
#   value       = 95
#   enabled     = true
#   entities    = [digitalocean_droplet.web.id]
#   description = "Alert about CPU usage"
# }
