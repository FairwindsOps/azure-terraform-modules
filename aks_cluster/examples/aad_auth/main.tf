## Create a resource group to place resources
resource "azurerm_resource_group" "aks" {
  name     = "myakscluster"
  location = "centralus"
}

## Create the virtual network for an AKS cluster
module "network" {
  source              = "git@github.com:FairwindsOps/azure-terraform-modules.git//virtual_network"
  region              = "centralus"
  resource_group_name = azurerm_resource_group.aks.name
  name                = "myakscluster"
  network_cidr_prefix = "10.64.0.0"
  network_cidr_suffix = 10
  subnets = [{
    name       = "aks-subnet"
    cidr_block = 16
  }]
}

## Create the AKS cluster with enable_aad_auth
module "cluster" {
  source              = "git@github.com:FairwindsOps/azure-terraform-modules.git//aks_cluster"
  region              = "centralus"
  cluster_name        = "myakscluster"
  resource_group_name = azurerm_resource_group.aks.name
  node_subnet_id      = module.network.subnet_ids[0] # use the subnet from the module above
  enable_aad_auth     = true
  network_plugin      = "azure"
  network_policy      = "calico"
  public_ssh_key_path = "/path/to/ssh_pub_key.rsa"
}
