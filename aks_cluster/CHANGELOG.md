# Changelog

## aks_cluster-v0.9.0
### Breaking

The explicit `azurerm` and `azuread` providers have been removed from this module, and are now listed as dependencies. To migrate:
1. Make a backup copy of the terraform state file
1. `terraform init` to update this module
1. `terraform refresh` to update the state file and remove the existing module-level providers. This happens silently.

## aks_cluster-v0.8.0
### Added
- `load_balancer_idle_timeout_in_minutes`
- `outbound_ports_allocated`
- `orchestrator_version` is now set on the default node pool

### Updated
- updated `azurerm` provider to `2.16.0`

## aks_cluster-v0.7.1

### Removed
- Removed `load_config_file` from the kubernetes provider

## aks_cluster-v0.7.0

### Added
- AAD integration is now optional and defaults to false, new variable `enable_aad_auth`
- Additional outputs for `kube_config`
- Created examples
- Updated `azurerm` provider to `v2.5.0`

### Removed
- A service principal password is no longer required. The module now uses `identity {type="SystemAssigned}` by default.

### Fixed
- conditional logic on optional oms_agent now works

## aks_cluster-v0.6.0

### Fixed

- added lifecycle ignore for node_taints

### Updated

- Upgraded azurerm provider version to 2.0.0

___

## aks_cluster-v0.5.0

### Added

- default tags
- additional_tags input

___

## aks_cluster-v0.4.0

### Added

- Support for AKS cluster add-ons

___

## aks_cluster-v0.3.1

### Fixed

- Updated module to ignore `node_count` changes.

___

## aks_cluster-v0.3.0

### Added

- additional output for kube_admin_config
- egress support with additional variables


___

## aks_cluster-v0.2.1

### Fixed

- fixed a bug that prevented AAD privileges from being granted properly if a non-admin executed Terraform.

___

## aks_cluster-v0.2.0

### Changed

- clarified AAD AKS application name

___

## aks_cluster-v0.1.0

- Initial release for the aks_cluster module
