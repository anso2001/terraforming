# Create an instance
resource "openstack_compute_instance_v2" "instance_1" {
  name              = "testing"
  image_id          = "aa97b237-095a-4edf-8ddd-4a18d3c6a8d4" # ubuntu-20.04-server-latest
  # ^ can also use image_name
  flavor_id         = "7a6a998f-ac7f-4fb8-a534-2175b254f75e" # v1-mini-1
  # ^ can also use flavor_name 
  key_pair          = "micke"
  security_groups   = ["default","${openstack_compute_secgroup_v2.secgroup_1.name}"]
  # region           = ""

  network {
      port = "${openstack_networking_port_v2.port_1.id}"
  }

  # create a volume and attach it
  block_device {
      source_type           = "blank"
      destination_type      = "volume"
      volume_size           = 10
      # boot_index            = 1
      delete_on_termination = true
  }
}

