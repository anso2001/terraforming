# Terraform Demo

## Config
Change the router_id in `variables.tf` to your own router id.


To find your router id:

```shell
openstack router list
```

Change the key_name in `variables.tf` to your own keypair.


To find your your keypairs:

```shell
openstack keypair list
```

Set your credentials in `main.tf` or use your OpenStack RC file and have it use env variables:

```shell
source username-openrc.sh
```

## Running

If you're running this for the first time:

```shell
terraform init
```

To create all resources:

```shell
terraform apply
```

## Destroy

To destroy all resources:

```shell
terraform destroy
```
