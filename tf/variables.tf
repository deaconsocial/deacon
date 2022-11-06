variable "region" {
  type        = string
  description = "(optional) DO Region in which to run"
  default     = "sfo3"
}

variable "ssh_keys" {
  type        = set(string)
  description = "List of SSH keys under ../ssh to add to the project."
  default     = ["andrew.pub"]
}

variable "app_scale" {
  type        = number
  description = "(optional) number of app servers"
  default     = 1
}

variable "app_instance_size" {
  type        = string
  description = "(optional) DO Droplet size to use for app servers"
  default     = "s-2vcpu-4gb-amd"
}

variable "app_image" {
  type        = string
  description = "(optional) DO base image to use for app servers"
  default     = "ubuntu-22-04-x64"
}

locals {
  environment = terraform.workspace
  prefix      = "deacon"
  domain      = "${terraform.workspace == "dev" ? "dev." : ""}deacon.social"
  base_tags = [
    "application:deacon",
    "environment:${terraform.workspace}"
  ]
}
