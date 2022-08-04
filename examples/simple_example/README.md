# Simple Example

This example illustrates how to use the `load-balanced-vms` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deployment\_name | The name of this particular deployment, will get added as a prefix to most resources. | `string` | n/a | yes |
| nodes | The number of nodes in the manged instance group | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| region | The Compute Region to deploy to | `string` | n/a | yes |
| zone | The Compute Zonbe to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_page | The url of the load balancer page in console |
| endpoint | The url of the front end which we want to surface to the user |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
