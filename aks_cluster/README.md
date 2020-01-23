## Virtual Network

This module provisions an AKS cluster within Azure.

## Requirements

- Terraform v0.12.13+
- Azure account and credentials
- Azure resource group
- Azure virtual network and subnet

## Example Usage
```
## Create a resource group to place resources
resource "azurerm_resource_group" "aks" {
  name     = "aks"
  location = "centralus"
}

## Create the virtual network for an AKS cluster
module "network" {
  source              = "git@github.com:FairwindsOps/azure-terraform-modules/virtual_network"
  region              = "centralus"
  resource_group_name = azurerm_resource_group.aks.name
  name                = "aks"
  network_cidr_prefix = "10.64.0.0"
  network_cidr_suffix = 10
  subnets = [{
    name       = "aks-subnet"
    cidr_block = 16
  }]
}

## Create the AKS cluster
module "cluster" {
  source                   = "git@github.com:FairwindsOps/azure-terraform-modules/aks_cluster"
  region                   = "centralus"
  cluster_name             = "aks-demo"
  resource_group_name      = azurerm_resource_group.default.name
  service_principal_secret = "some-super-secret-password"
  vnet_subnet_id           = module.network.subnets[0] #use the subnet from the module above
  network_plugin           = "azure"
  network_policy           = "calico"
  public_ssh_key_path      = "/path/to/ssh_pub_key.rsa"
}
```

## Configuration

The following table lists the configurable parameters that this module accepts.

| Parameter                  | Description                                               | Default     |
|----------------------------|-----------------------------------------------------------|-------------|
| `admin_username`           | The username set in linux_profile                         | `"admin"`   |
| `cluster_name`             | Name of the AKS cluster                                   | `None`      |
| `default_node_pool`        | The default_node_pool nap (see table below)               | `see below` |
| `docker_bridge_cidr`       | The docker daemon host cidr                               | `null`      |
| `kubernetes_version`       | The Kubernetes AKS version                                | `null`      |
| `load_balancer_sku`        | The load balancer type. Supported values: basic, standard | `standard`  |
| `network_plugin`           | The CNI network plugin to use (only azure, or kubenet)    | `kubenet`   |
| `node_subnet_id`           | The subnet ID for the default node pool                   | `None`      |
| `network_policy`           | The network policy for the CNI, dependent on plugin type  | `null`      |
| `pod_cidr`                 | Network CIDR range for the pod network                    | `null`      |
| `public_ssh_key_path`      | The SSH public key attached the linux_profile             | `None`      |
| `region`                   | The Azure region                                          | `None`      |
| `resource_group_name`      | The resource group to place the AKS cluster in            | `None`      |
| `service_cidr`             | The CIDR range for Kubernetes services                    | `null`      |
| `service_principal_secret` | Secret password attached to the service principal         | `None`      |
| `tags`                     | A map of tags to be auto-attached to resources            | `{}`        |

## Outputs

## Considerations
