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

