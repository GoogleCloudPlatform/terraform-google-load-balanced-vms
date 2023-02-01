# Load balanced managed VMs

This module was generated from [terraform-google-module-template](https://github.com/terraform-google-modules/terraform-google-module-template/), which by default generates a module that simply creates a GCS bucket. As the module develops, this README should be updated.

The resources/services/activations/deletions that this module will create/trigger are:

* Instance Template
* Managed Instance Group
* Load Balancer

### Tagline
Create a Managed Instance Group exposed by a HTTP Load Balancer.

### Detailed
Create a virtual machine cluster with a load balancer to make the VMs globally available, and instantaneously manage traffic.
You can choose whether to deploy your solution through the console directly or download as Terraform on GitHub  to deploy later.

### Architecture
1. The user makes a request to the application deployed on Compute Engine and the request first lands on Cloud Load Balancing.
1. Cloud Load Balancing distributes the traffic to the Compute Engine Managed Instance Group (MIG) which is set up to scale to multiple instances based on traffic growth.

## Documentation
- [Architecture Diagram](https://github.com/GoogleCloudPlatform/terraform-google-load-balanced-vms/blob/main/assets/load_balanced_vms_v1.svg)

## Usage

Basic usage of this module is as follows:

```hcl
module "load_balanced_vms" {
  source  = "terraform-google-modules/load-balanced-vms/google"
  version = "~> 0.1"

  project_id  = "<PROJECT ID>"
  region = "us-central1"
  zone = "us-central1-a"
  nodes = "3"
  deployment_name = "load-balanced-vms"
}
```

Functional examples are included in the
[examples](./examples/) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deployment\_name | The name of this particular deployment, will get added as a prefix to most resources. | `string` | `"load-balanced-vms"` | no |
| enable\_apis | Whether or not to enable underlying apis in this solution. . | `string` | `true` | no |
| labels | A map of labels to apply to contained resources. | `map(string)` | <pre>{<br>  "load-balanced-vms": true<br>}</pre> | no |
| network\_id | VPC network to deploy VMs in. A VPC will be created if not specified. | `string` | `""` | no |
| network\_project\_id | Shared VPC host project ID if a Shared VPC is provided via network\_id. | `string` | `""` | no |
| nodes | The number of nodes in the managed instance group | `string` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| region | The Compute Region to deploy to | `string` | n/a | yes |
| subnet\_self\_link | Subnetwork to deploy VMs in. A Subnetwork will be created if not specified. | `string` | `""` | no |
| zone | The Compute Zone to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| console\_page\_for\_load\_balancer | The url of the load balancer page in console |
| load\_balancer\_endpoint | The url of the front end which we want to surface to the user |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.13
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.0

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Compute Admin: `roles/compute.admin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

- Google Cloud Compute API: `compute.googleapis.com`

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html


This is not an official Google product
