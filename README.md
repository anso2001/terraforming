# Terraform Demo

## Config
Change the router_id in `variables.tf` to your own router id.


To find your router id:

```shell
openstack router list
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
