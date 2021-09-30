## PROVIDER
# Configure the OpenStack Provider
provider "openstack" {
  #user_name          = "" # use $OS_USERNAME
  #tenant_name        = "" # use $OS_PROJECT_NAME
  #tenant_id          = "" # use $OS_PROJECT_ID
  #password           = "" # use $OS_PASSWORD
  #auth_url           = "" # use $OS_AUTH_URL
  #region             = "" # use $OS_REGION_NAME
}

## NETWORK
# Create network
resource "openstack_networking_network_v2" "network_1" {
  name                = var.network_name
  admin_state_up      = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "subnet_1" {
  name                = var.subnet_name
  network_id          = "${openstack_networking_network_v2.network_1.id}"
  cidr                = var.subnet_cidr
  ip_version          = 4
  dns_nameservers     = var.dns_ip
}

# Create Security Groups
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name                = "TerraformSG"
  description         = "Terraform SG for Port 80 and 443"

  rule {
    from_port         = 80
    to_port           = 80
    ip_protocol       = "tcp"
    cidr              = "0.0.0.0/0"
  }

  rule {
    from_port         = 443
    to_port           = 443
    ip_protocol       = "tcp"
    cidr              = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "secgroup_2" {
  name                = "TerraformSSH"
  description         = "Terraform SH for Port 22"

  rule {
    from_port         = 22
    to_port           = 22
    ip_protocol       = "tcp"
    cidr              = "0.0.0.0/0" # only for demo purposes, tighten up in live scenario
  }
}

# Create a port
resource "openstack_networking_port_v2" "port_1" {
  name                = "port_1"
  network_id          = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up      = "true"
  security_group_ids  = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    subnet_id         = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address        = var.port_ip
  }
}

# Connect the subnet to the router
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id           = var.router_id
  subnet_id           = "${openstack_networking_subnet_v2.subnet_1.id}"
}

# Allocate Floating IP
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool                = var.fip_pool
}

## INSTANCE
# Create an instance
resource "openstack_compute_instance_v2" "instance_1" {
  name                = var.instance_name
  image_name          = var.image_name
  flavor_name         = var.flavor_name
  key_pair            = var.key_name
  security_groups     = ["default","${openstack_compute_secgroup_v2.secgroup_1.name}","${openstack_compute_secgroup_v2.secgroup_2.name}"]
  user_data           = var.cloudconfig_web

  network {
    port              = "${openstack_networking_port_v2.port_1.id}"
  }
}

# Associate Floating IP
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip         = "${openstack_networking_floatingip_v2.floatip_1.address}"
  port_id             = "${openstack_networking_port_v2.port_1.id}"
}
