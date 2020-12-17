# Create Service Principal for AKS cluster
resource "azuread_application" "aks_sp_application" {
  count                      = local.use_aks_sp ? 1 : 0
  name                       = "${var.cluster_name}-aks"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_service_principal" "aks_sp" {
  count          = local.use_aks_sp ? 1 : 0
  application_id = azuread_application.aks_sp_application[0].application_id
}

resource "azuread_service_principal_password" "aks_sp_password" {
  count = local.use_aks_sp ? 1 : 0
  lifecycle {
    ignore_changes = [end_date]
  }
  service_principal_id = azuread_service_principal.aks_sp[0].id
  value                = var.aks_sp_secret
  end_date             = timeadd(timestamp(), "43800h") # 5 years
}

resource "azurerm_role_assignment" "aks_sp_role_assignment" {
  count                = local.use_aks_sp ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aks_sp[0].id

  depends_on = [
    azuread_service_principal_password.aks_sp_password
  ]
}

# Create a cluster admin group
resource "azuread_group" "aks-aad-clusteradmins" {
  count = var.enable_aad_auth ? 1 : 0
  name  = "${var.cluster_name}-clusteradmin"
}
