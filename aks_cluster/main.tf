# Configure the Azure Provider
provider "azurerm" {}

resource "azurerm_kubernetes_cluster" "cluster" {
  depends_on          = ["null_resource.delay_after_sp_created"]
  name                = var.cluster_name
  location            = var.region
  dns_prefix          = var.cluster_name
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.public_ssh_key_path)
    }
  }

  role_based_access_control {
    enabled = true
  }

  default_node_pool {
    name                  = "defaultpool"
    node_count            = var.default_node_pool.node_count
    enable_auto_scaling   = var.default_node_pool.enable_auto_scaling
    enable_node_public_ip = var.default_node_pool.enable_node_public_ip
    node_taints           = var.default_node_pool.node_taints
    os_disk_size_gb       = var.default_node_pool.os_disk_size_gb
    min_count             = var.default_node_pool.min_count
    max_count             = var.default_node_pool.max_count
    vm_size               = var.default_node_pool.vm_size
    availability_zones    = var.default_node_pool.availability_zones
    max_pods              = var.default_node_pool.max_pods
    vnet_subnet_id        = var.node_subnet_id
  }

  service_principal {
    client_id     = azuread_service_principal.service_principal.application_id
    client_secret = azuread_service_principal_password.sp_password.value
  }

  network_profile {
    network_plugin     = var.network_plugin
    load_balancer_sku  = var.load_balancer_sku
    network_policy     = var.network_policy
    docker_bridge_cidr = var.docker_bridge_cidr
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
  }
}
