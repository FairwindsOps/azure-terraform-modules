data "azurerm_subscription" "current" {}

locals {
  ## The following locals are used when the cluser is created with static egress ip addresses. See the docs for usage.
  load_balancer_profile_enabled = var.managed_outbound_ip_count != null || var.outbound_ip_prefix_ids != null || var.outbound_ip_address_ids != null ? true : null
  load_balancer_profile = {
    managed_outbound_ip_count = var.managed_outbound_ip_count
    outbound_ip_address_ids   = var.outbound_ip_address_ids
    outbound_ip_prefix_ids    = var.outbound_ip_prefix_ids
  }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  depends_on = [null_resource.delay_after_sp_created, null_resource.consent_delay]
  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
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
    azure_active_directory {
      client_app_id     = azuread_service_principal.client_sp.application_id
      server_app_id     = azuread_service_principal.server_sp.application_id
      server_app_secret = azuread_service_principal_password.server_sp_password.value
      tenant_id         = data.azurerm_subscription.current.tenant_id
    }
  }

  default_node_pool {
    name                  = "default"
    node_count            = var.node_count
    enable_auto_scaling   = var.enable_auto_scaling
    enable_node_public_ip = var.enable_node_public_ip
    node_taints           = var.node_taints
    os_disk_size_gb       = var.os_disk_size_gb
    min_count             = var.node_min_count
    max_count             = var.node_max_count
    vm_size               = var.node_type
    availability_zones    = var.node_availability_zones
    max_pods              = var.node_max_pods
    vnet_subnet_id        = var.node_subnet_id
  }



  service_principal {
    client_id     = azuread_service_principal.aks_sp.application_id
    client_secret = azuread_service_principal_password.aks_sp_password.value
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
    dynamic "load_balancer_profile" {
      for_each = local.load_balancer_profile_enabled == null ? [] : list(local.load_balancer_profile)
      content {
        managed_outbound_ip_count = local.load_balancer_profile.managed_outbound_ip_count
        outbound_ip_prefix_ids    = local.load_balancer_profile.outbound_ip_prefix_ids
        outbound_ip_address_ids   = local.load_balancer_profile.outbound_ip_address_ids
      }
    }
    network_policy     = var.network_policy
    docker_bridge_cidr = var.docker_bridge_cidr
    pod_cidr           = var.pod_cidr
    service_cidr       = var.service_cidr
  }
}
