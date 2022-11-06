resource "digitalocean_record" "mailgun_spif" {
  domain = digitalocean_domain.deacon.id
  type   = "TXT"
  name   = "mail"
  value  = "v=spf1 include:mailgun.org ~all"
}

resource "digitalocean_record" "mailgun_dkim" {
  domain = digitalocean_domain.deacon.id
  type   = "TXT"
  name   = "mx._domainkey.mail"
  value  = "k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAug8szeWMjIeXq2o7qzW0+EFvfMsmyCuyU+GDo2vwX8m4rDgrNETtZEw664RKVtCxukoaSfyCaNLU1Yg+MT9CW91PuP/xxxD8Atjeh7JOxroHU/+A8aYFpFCrH6XhLV5THXeKsnY2eRDr95bkwRE0nzzx1lPu9krFig6JQA+Ni6i1M+OT4WeUzgJpOmiWM71X+EBkCfJoA7cHbChUql4M3PXXHc3DiVbGoFEQ0eUNNc+/SxmJJUqB4le1Y/vXxCiO91JLqBpzUaFucolPu+pwr8M62NXrVL73aDryXTg4ADiOSlFTcQ7iuBWxoSLuR2viOeQznf9mu/42XzG1mpT1rQIDAQAB"
}

resource "digitalocean_record" "mailgun_mx1" {
  domain   = digitalocean_domain.deacon.id
  type     = "MX"
  name     = "mail"
  priority = 10
  value    = "mxa.mailgun.org."
}

resource "digitalocean_record" "mailgun_mx2" {
  domain   = digitalocean_domain.deacon.id
  type     = "MX"
  name     = "mail"
  priority = 10
  value    = "mxb.mailgun.org."
}

resource "digitalocean_record" "mailgun_tracking" {
  domain = digitalocean_domain.deacon.id
  type   = "CNAME"
  name   = "email.mail"
  value  = "mailgun.org."
}
