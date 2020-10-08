
locals {
  network_cidr = "${var.network_cidr_prefix}/${var.network_cidr_suffix}"
  network_objs = [
    for i, n in var.subnets : {
      name     = n.name
      new_bits = abs(var.network_cidr_suffix - n.cidr_block)
  }]
}

module "subnet_addrs" {
  source          = "git@github.com:hashicorp/terraform-cidr-subnets.git?ref=v1.0.0"
  base_cidr_block = local.network_cidr
  networks        = local.network_objs
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "${var.name}-network"
  address_space       = [module.subnet_addrs.base_cidr_block]
  location            = var.region
  resource_group_name = var.resource_group_name
  dynamic "subnet" {
    for_each = module.subnet_addrs.network_cidr_blocks
    content {
      name           = subnet.key
      address_prefix = subnet.value
    }
  }

  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection_plan ? [1] : []
    content {
      enable = var.enable_ddos_protection_plan
      id = var.ddos_protection_plan_id
    }
  }

  tags = merge(var.additional_tags, {
    created-by    = "Terraform"
    module-source = "github.com/FairwindsOps/azure-terraform-modules/virtual-network"
  })
}
