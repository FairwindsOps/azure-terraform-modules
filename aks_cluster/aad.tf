resource "azuread_application" "ad_server_application" {
  name                       = "${var.cluster_name}-srv"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
  identifier_uris            = ["https://${var.cluster_name}-srv"]
  reply_urls                 = ["https://${var.cluster_name}-srv"]
  type                       = "webapp/api"
  group_membership_claims    = "All"
  required_resource_access {
    # Microsoft Graph
    resource_app_id = "00000003-0000-0000-c000-000000000000"
    # Read directory data (Application Permission)
    resource_access {
      id   = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
    # Read directory data (Delegated Permission)
    resource_access {
      id   = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }
    # Sign in and read user profile
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }
  required_resource_access {
    # Windows Azure Active Directory
    resource_app_id = "00000002-0000-0000-c000-000000000000"
    # 311a71cc-e848-46a1-bdf8-97ff7156d8e6 	
    resource_access {
      id   = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }
}


resource "azuread_application" "ad_client_application" {
  name                       = "${var.cluster_name}-client"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
  type                       = "native"
  reply_urls                 = ["https://login.microsoftonline.com/common/oauth2/nativeclient"]
  required_resource_access {
    resource_app_id = azuread_application.ad_server_application.application_id
    resource_access {
      id   = azuread_application.ad_server_application.oauth2_permissions[0].id
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "server_sp" {
  application_id = azuread_application.ad_server_application.application_id
}

resource "azuread_service_principal_password" "server_sp_password" {
  lifecycle {
    ignore_changes = [end_date]
  }
  service_principal_id = azuread_service_principal.server_sp.id
  value                = var.auth_server_sp_secret
  end_date             = timeadd(timestamp(), "43800h") # 5 years
}

resource "azuread_service_principal" "client_sp" {
  application_id = azuread_application.ad_client_application.application_id
}

resource "azuread_service_principal_password" "client_sp_password" {
  lifecycle {
    ignore_changes = [end_date]
  }
  service_principal_id = azuread_service_principal.client_sp.id
  value                = var.auth_client_sp_secret
  end_date             = timeadd(timestamp(), "43800h") # 5 years
}

# Create Service Principal for AKS cluster
resource "azuread_application" "aks_sp_application" {
  name                       = var.cluster_name
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
}

resource "azuread_service_principal" "aks_sp" {
  application_id = azuread_application.aks_sp_application.application_id
}

resource "azuread_service_principal_password" "aks_sp_password" {
  lifecycle {
    ignore_changes = [end_date]
  }
  service_principal_id = azuread_service_principal.aks_sp.id
  value                = var.aks_sp_secret
  end_date             = timeadd(timestamp(), "43800h") # 5 years
}

resource "azurerm_role_assignment" "aks_sp_role_assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aks_sp.id

  depends_on = [
    azuread_service_principal_password.aks_sp_password
  ]
}

# Create a cluster admin group
resource "azuread_group" "aks-aad-clusteradmins" {
  name = "${var.cluster_name}-clusteradmin"
}

# We need to wait for service principals to propagate in Azure
resource "null_resource" "delay_after_sp_created" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    azuread_service_principal.server_sp,
    azuread_service_principal.client_sp,
    azuread_service_principal.aks_sp
  ]
}

# Terraform does not provide a way to override Admin consent, we need to shell out to az cli
resource "null_resource" "grant_server_application_privs" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.ad_server_application.application_id}"
  }
  depends_on = [
    null_resource.delay_after_sp_created
  ]
}
resource "null_resource" "grant_client_application_privs" {
  provisioner "local-exec" {
    command = "az ad app permission admin-consent --id ${azuread_application.ad_client_application.application_id}"
  }
  depends_on = [
    null_resource.delay_after_sp_created
  ]
}

# Wait for privs to propagate
resource "null_resource" "consent_delay" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  depends_on = [
    null_resource.grant_server_application_privs,
    null_resource.grant_client_application_privs
  ]
}
