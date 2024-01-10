## Mongodb Example


<br>
This example will be very useful for users who are new to a module and want to quickly learn how to use it. By reviewing the examples, users can gain a better understanding of how the module works, what features it supports, and how to customize it to their specific needs.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.70.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure"></a> [azure](#module\_azure) | saturnops/mongodb/kubernetes//provider/azure | n/a |
| <a name="module_mongodb"></a> [mongodb](#module\_mongodb) | saturnops/mongodb/kubernetes | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_credential"></a> [mongodb\_credential](#output\_mongodb\_credential) | MongoDB credentials used for accessing the MongoDB database. |
| <a name="output_mongodb_endpoints"></a> [mongodb\_endpoints](#output\_mongodb\_endpoints) | MongoDB endpoints in the Kubernetes cluster. |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_azure"></a> [azure](#module\_azure) | saturnops/mongodb/kubernetes//modules/resources/azure | n/a |
| <a name="module_mongodb"></a> [mongodb](#module\_mongodb) | saturnops/mongodb/kubernetes | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mongodb_credential"></a> [mongodb\_credential](#output\_mongodb\_credential) | MongoDB credentials used for accessing the MongoDB database. |
| <a name="output_mongodb_endpoints"></a> [mongodb\_endpoints](#output\_mongodb\_endpoints) | MongoDB endpoints in the Kubernetes cluster. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
