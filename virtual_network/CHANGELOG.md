# Changelog

## virtual_network-v0.8.0
### Added

Support for Azure DDoS Protection Plans.  Inputs:
- enable_ddos_protection_plan `boolean`
- ddos_protection_plan_id `string` Id of a protection plan.

## virtual_network-v0.7.0
### Breaking

The explicit `azurerm` and `azuread` providers have been removed from this module, and are now listed as dependencies. To migrate:
1. Make a backup copy of the terraform state file
1. `terraform init` to update this module
1. `terraform refresh` to update the state file and remove the existing module-level providers. This happens silently.

## virtual_network-v0.6.0

### Updated
- updated `azurerm` provider to `2.16.0`

## virtual_network-v0.5.0

### Updated
- Upgraded azurerm provider version to 2.5.0

## virtual_network-v0.4.0

### Updated

- Upgraded azurerm provider version to 2.0.0

___

## virtual_network-v0.3.0

### Added

- default tags
- additional_tags input

___

## virtual_network-v.2.0

### Changed

- renamed output subnets to subnet_ids

### Added

- added subnet_map output

___

## virtual_network-v0.1.0

- Initial release for the virtual network module
