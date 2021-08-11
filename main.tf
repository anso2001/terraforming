## INIT
# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  #user_name   = "" # use $OS_USERNAME
  #tenant_name = "" # use $OS_PROJECT_NAME
  #tenant_id    = "" # use $OS_PROJECT_ID
  #password    = "" # use $OS_PASSWORD
  #auth_url    = "" # use $OS_AUTH_URL
  #region      = "" # use $OS_REGION_NAME
}

## INSTANCES
# Create an instance
resource "openstack_compute_instance_v2" "instance_1" {
  name              = var.instance_name
  image_id          = var.image_id # name: ubuntu-20.04-server-latest
  # ^ can also use image_name
  flavor_id         = var.flavor_id # v1-mini-1
  # ^ can also use flavor_name 
  key_pair          = var.key_name
  #security_groups   = ["default","${openstack_compute_secgroup_v2.secgroup_1.name}"]
  # region           = ""
  # count            = 


  network {
      port = "${openstack_networking_port_v2.port_1.id}"
  }

  # DON'T NEED THIS FOR NOW
  # create a volume and attach it
  # block_device {
  #     source_type           = "blank"
  #     destination_type      = "volume"
  #     volume_size           = 10
  #     # boot_index            = 1
  #     delete_on_termination = true
  # }
}

## NETWORK
# Create network
resource "openstack_networking_network_v2" "network_1" {
  name           = var.network_name
  admin_state_up = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "subnet_1" {
  name            = var.subnet_name
  network_id      = "${openstack_networking_network_v2.network_1.id}"
  cidr            = var.subnet_cidr
  ip_version      = 4
  dns_nameservers = var.dns_ip
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
    ip_address = var.port_ip
  }
}

# Connect the subnet to the router
#+ later: create a new router from scratch
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = var.router_id # replace with new router when created "${openstack_networking_router_v2.router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

# Allocate Floating IP
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = var.fip_pool
}

# Associate Floating IP
resource "openstack_networking_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  port_id     = "${openstack_networking_port_v2.port_1.id}"
}