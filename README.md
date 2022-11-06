# deacon.social

This repository manages the infrastructure for the Mastodon instance
at [deacon.social](https://deacon.social).

## Getting Started

## Remote Access

You will need the following:

- A clone of this repository
- Access to the DigitalOcean project housing the resources for this project.
- A DigitalOcean personal access token.
- An SSH keypair used to authorize you to droplets.

### Local Config

We use direnv to manage environment variables for development. Create a file called `.envrc.local` in the root directory of the repo. This file is not tracked. Export any variables declared in `.envrc` with the value of `"OVERRIDE_ME"`.

## Architecture

<!-- TODO: Add a diagram -->
- DNS is provided by DigitalOcean and is managed exclusively in Terraform
- App is running on a manually configured DO Droplet
- HTTPS ingress is provided via a DO Load Balancer
- Load balancer is configured to use a LetsEncrypt cert (automatic rotation before expiry)
- DB is a DO-managed Postgres db
- Mail is delivered via MailGun's SMTP service

### TODO

#### Infrastructure

- [x] Add firewall to allow db access from app servers only
- [x] Add firewall to allow only the following app server access: HTTP from load balancer, SSH from anywhere.
- [x] Setup mail sending with MailGun
- [ ] Externalize TF state (use DO spaces?)
- [ ] Use DO spaces for file uploads
- [ ] Automate provisioning of Mastodon app server
- [ ] Implement basic secret management (db creds, mailgun credentials)
- [ ] Harden server (fail2ban, disable root login)
- [ ] Set up monitoring alerting

#### Site Management

- [ ] Create site policy
- [ ] Create a list of banned servers (copy from a large community server as a starting point)
- [ ] Create a "Getting Started" doc aimed at users coming from Twitter.
- [ ] Test, test, test!
