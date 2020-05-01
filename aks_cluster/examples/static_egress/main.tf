## Create Public ips for AKS egress
resource "azurerm_public_ip" "egress" {
  count               = 3
  name                = "egress-${count.index}"
  location            = "centralus"
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

## Create the AKS cluster
module "cluster" {
  source                  = "git@github.com:FairwindsOps/azure-terraform-modules.git//aks_cluster"
  region                  = "centralus"
  cluster_name            = "myakscluster"
  resource_group_name     = azurerm_resource_group.aks.name
  node_subnet_id          = module.network.subnet_ids[0]
  network_plugin          = "azure"
  network_policy          = "calico"
  outbound_ip_address_ids = azurerm_public_ip.egress.*.id # input egress ids from above
  public_ssh_key_path     = "/path/to/ssh_pub_key.rsa"
}

## Create AKS cluster with dynamically provisioned IP addresses
module "dynamic-cluster" {
  source                    = "git@github.com:FairwindsOps/azure-terraform-modules.git//aks_cluster"
  region                    = "centralus"
  cluster_name              = "mydynamicakscluster"
  resource_group_name       = azurerm_resource_group.aks.name
  node_subnet_id            = module.network.subnet_ids[0]
  network_plugin            = "azure"
  network_policy            = "calico"
  managed_outbound_ip_count = 3
  public_ssh_key_path       = "/path/to/ssh_pub_key.rsa"
}
