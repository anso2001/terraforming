# Create network
resource "openstack_networking_network_v2" "network_1" {
  name           = "tf_network"
  admin_state_up = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "tf_subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "192.168.199.0/24"
  ip_version = 4
}

# Create Security Group
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "TF SG SSH"
  description = "Terraform SG for external SSH"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# Create a port
resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    subnet_id  = "${openstack_networking_subnet_v2.subnet_1.id}"
    ip_address = "192.168.199.10"
  }
}

# Connect the subnet to the router
#+ later: create a new router from scratch
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "71b2edab-5000-43da-b191-d572f1bc22b3" # "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

# Allocate Floating IP
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool      = "elx-public1"
}

# NOT WORKING with floatip_1:
#+ "floatip_1" has not been declared in the root module
#+ very much temp workaround in place
# Associate Floating IP
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  port_id     = "${openstack_networking_port_v2.port_1.id}"
}