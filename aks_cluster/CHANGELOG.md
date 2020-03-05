# Changelog

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
