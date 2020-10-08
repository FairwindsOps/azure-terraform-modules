# Virtual Network

This module provisions a virtual network within Azure. By default it will supply two subnets. Under the hood, this module relies on the [Hashicorp subnet module](https://github.com/hashicorp/terraform-cidr-subnets/tree/v1.0.0). It extends the usage a bit by allowing users to input a `cidr_block`, rather than calculate the `new_bits` ahead of time. Review the configuration and example section for customizing the virtual network.

## Requirements

- Terraform v0.12.13+
- Azure account and credentials
- Azure resource group

## Example Usage
```
## Create a resource group to place resources
resource "azurerm_resource_group" "default" {
  name     = "network-resource-group"
  location = "centralus"
}

## basic network using module defaults
module "basic_network" {
  source              = "git@github.com/FairwindsOps/azure-terraform-modules/virtual_network"
  region              = local.region
  resource_group_name = azurerm_resource_group.default.name
  name                = local.name
  tags                = local.tags
}

## advanced network using multiple subnets
module "adv_network" {
  source              = "git@github.com/FairwindsOps/azure-terraform-modules/virtual_network"
  region = "centralus"
  resource_group_name = azurerm_resource_group.default.name
  name = "advanced-network"
  network_cidr_prefix = "10.20.0.0"
  network_cidr_suffix = "16"
  subnets = [
    {
      name = "large_subnet"
      cidr_block = 18
    },
    {
      name = "medium_subnet"
      cidr_block = 20
    },
    {
      name = "small_subnet"
      cidr_block = 24
    }
  ]
}
```


## Configuration

The following table lists the configurable parameters that this module accepts.

| Parameter                     | Description                                              | Default        |
|-------------------------------|----------------------------------------------------------|----------------|
| `ddos_protection_plan_id`     | id of a DDoS Protection Plan                             | `None`         |
| `enable_ddos_protection_plan` | Enable plan if `true`                                    | `false`        |
| `region`                      | Azure region                                             | `None`         |
| `name`                        | Name of the virtual network                              | `None`         |
| `network_cidr_prefix`         | The network cidr ip prefix                               | `"10.0.0.0"`   |
| `network_cidr_suffix`         | The network cidr suffix                                  | `8`            |
| `networks`                    | A list of objects that contain subnets and desired size  | `[{`<br>`name = "subnet-1"`<br>`cidr_block = 18`<br>`},`<br>`{`<br>`name = "subnet-2"`<br>`cidr_block = 18`<br>`}]` |
| `resource_group_name`         | The resource group to place the Azure network            | `None`         |
| `additional_tags`             | A map of tags to be appended to Azure objects            | `{}`           |

## Outputs
| Output       | Description                                    |
| -------------|------------------------------------------------|
| `id`         | The ID of the virtual_network                  |
| `name`       | The name of the virtual network                |
| `subnet_ids` | An array containing all subnets ids            |
| `subnet_map` | An array containing maps of subnet id and name |

## Considerations

- This module relies on the subnetting output from [https://github.com/hashicorp/terraform-cidr-subnets/tree/v1.0.0]
