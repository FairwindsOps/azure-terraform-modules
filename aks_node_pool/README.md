# AKS Node Pool

This module provisions an AKS node pool that will attach to an AKS cluster. The node pool must be deployed to the same subnet as the default AKS node pool.

## Requirements

- Terraform v0.12.13+
- Azure account and credentials
- Azure resource group
- Azure virtual network and subnet
- AKS cluster

## Example Usage
```
## Create a resource group to place resources
resource "azurerm_resource_group" "aks" {
  name     = "aks"
  location = "centralus"
}

## Create the virtual network for an AKS cluster
module "network" {
  source              = "git@github.com:FairwindsOps/azure-terraform-modules.git//virtual_network"
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
  source                   = "git@github.com:FairwindsOps/azure-terraform-modules.git//aks_cluster"
  region                   = "centralus"
  cluster_name             = "myakscluster"
  resource_group_name      = azurerm_resource_group.aks.name
  aks_sp_secret            = "some-super-secret-password"
  client_sp_secret         = "some-super-secret-password"
  server_sp_secret         = "some-super-secret-password"  
  node_subnet_id           = module.network.subnet_ids[0] # use the subnet from the module above
  network_plugin           = "azure"
  network_policy           = "calico"
  public_ssh_key_path      = "/path/to/ssh_pub_key.rsa"
}

## Create the node pool
module "node_pool" {
  source             = "git@github.com:FairwindsOps/azure-terraform-modules.git//aks_node_pool"
  name               = "myakspool"
  aks_cluster_id     = module.cluster.id
  kubernetes_version = "1.16.9"
  node_subnet_id     = module.network.subnets[0]
}

```

## Configuration

The following table lists the configurable parameters that this module accepts.

| Parameter               | Description                                                    | Default            |
|-------------------------|----------------------------------------------------------------|--------------------|
| `aks_cluster_id`        | The ID of the AKS cluster                                      | `None`             |
| `availability_zones`    | Azure availability zones to use                                | `[1, 2, 3]`        |
| `enable_auto_scaling`   | Boolean to enable/disable autoscaling                          | `true`             |
| `enable_node_public_ip` | Boolean to enable allocation of public ips to nodes            | `false`            |
| `kubernetes_version`    | Kubernetes version the node pool will run                      | `None`             |
| `max_count`             | Max amount of nodes to autoscale                               | `null`             |
| `max_pods`              | Max amount of pods per node (subject to CNI)                   | `200`              |
| `min_count`             | Min amount of nodes for autoscaling (must be greater than 0)   | `null`             |
| `name`                  | The name of the node_pool                                      | `None`             |
| `node_count`            | The initial node count                                         | `1`                |
| `node_subnet_id`        | Subnet ID to place the node pool. Must be same as default pool | `None`             |
| `node_taints`           | Taints to apply to nodes                                       | `null`             |
| `os_disk_size_gb`       | The root disk size for VMs                                     | `35`               |
| `os_type`               | Linux or Windows                                               | `Linux`            |
| `vm_size`               | The Azure VM instance type                                     | `"Standard_D2_v2"` |

## Outputs

## Considerations
