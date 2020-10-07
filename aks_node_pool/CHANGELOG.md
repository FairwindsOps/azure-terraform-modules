# Changelog

## aks_node_pool-v0.5.0
### Breaking

The explicit `azurerm` and `azuread` providers have been removed from this module, and are now listed as dependencies. To migrate:
1. Make a backup copy of the terraform state file
1. `terraform init` to update this module
1. `terraform refresh` to update the state file and remove the existing module-level providers. This happens silently.

## aks_node_pool-v0.4.0
### Added
- `kubernetes_version` is now a required variable

### Updated
- updated `azurerm` provider to `2.16.0`

## aks_node_pool-v0.3.0
### Updated
- bumped azurerm provider to v2.5.0

## aks_node_pool-v0.2.0

### Fixed

- added lifecycle ignore for node_taints

### Updated

- Upgraded azurerm provider version to 2.0.0

___

## aks_node_pool-v0.1.0

- Initial release for the aks_node_pool module
