resource "azurerm_kubernetes_cluster_node_pool" "node_pool" {
  lifecycle {
    ignore_changes = [
      node_taints,
      node_count
    ]
  }
  name                  = var.name
  kubernetes_cluster_id = var.aks_cluster_id
  vm_size               = var.vm_size
  node_count            = var.node_count
  availability_zones    = var.availability_zones
  enable_auto_scaling   = var.enable_auto_scaling
  enable_node_public_ip = var.enable_node_public_ip
  max_count             = var.max_count
  min_count             = var.min_count
  max_pods              = var.max_pods
  node_taints           = var.node_taints
  orchestrator_version  = var.kubernetes_version
  os_disk_size_gb       = var.os_disk_size_gb
  os_type               = var.os_type
  vnet_subnet_id        = var.node_subnet_id
}
