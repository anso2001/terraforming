## VARIABLES
# Make changes here

variable "instance_name" {
  type    = string
  default = "tf-web"
}

variable "image_name" {
  type    = string
  default = "ubuntu-20.04-server-latest"
}

variable "flavor_name" {
  type    = string
  default = "v1-mini-1"
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

variable "region" {
  type    = string
  default = "sto1"
}

variable "cloudconfig_web" {
  type    = string
  default = <<EOF
#cloud-config
system_info:
  default_user:
    name: hxp
packages:
 - nginx
EOF
}
