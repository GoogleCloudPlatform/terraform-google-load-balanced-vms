# Simple Example

This example illustrates how to use the `load-balanced-vms` module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_service_list"></a> [gcp\_service\_list](#input\_gcp\_service\_list) | The list of apis necessary for the project | `list(string)` | <pre>[<br>  "compute.googleapis.com"<br>]</pre> | no |
| <a name="input_nodes"></a> [nodes](#input\_nodes) | The number of nodes in the manged instance group | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to deploy to | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The Compute Region to deploy to | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The Compute Zonbe to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_console_page"></a> [console\_page](#output\_console\_page) | The url of the load balancer page in console |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The url of the front end which we want to surface to the user |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
