## VARIABLES
# Make changes here

variable "instance_name" {
  type    = string
  default = "testing"
}

variable "image_id" { # use name instead?
  type    = string
  default = "aa97b237-095a-4edf-8ddd-4a18d3c6a8d4" # ubuntu-20.04-server-latest
}

variable "flavor_id" { # use name instead?
  type    = string
  default = "7a6a998f-ac7f-4fb8-a534-2175b254f75e" # v1-mini-1
}

variable "key_name" {
  type    = string
  default = "micke"
}

variable "network_name" {
  type    = string
  default = "tf_network"
}

variable "subnet_name" {
  type    = string
  default = "tf_subnet_1"
}

variable "subnet_cidr" {
  type    = string
  default = "192.168.199.0/24"
}

variable "dns_ip" {
  type    = list(string)
  default = [ "8.8.8.8", "8.8.4.4" ]
}

variable "port_ip" {
  type    = string
  default = "192.168.199.10"
}

variable "router_id" {
  type    = string
  default = "71b2edab-5000-43da-b191-d572f1bc22b3"
}

variable "fip_pool" {
  type    = string
  default = "elx-public1"
}