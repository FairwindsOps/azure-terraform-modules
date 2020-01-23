resource "azuread_application" "ad_application" {
  name                       = var.cluster_name
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.ad_application.application_id
}

resource "azuread_service_principal_password" "sp_password" {
  lifecycle {
    ignore_changes = [end_date]
  }
  service_principal_id = azuread_service_principal.service_principal.id
  value                = var.service_principal_secret
  end_date             = timeadd(timestamp(), "43800h")
}

# This is dumb. And a hack. https://github.com/terraform-providers/terraform-provider-azuread/issues/128
resource "null_resource" "delay_after_sp_created" {
  provisioner "local-exec" {
    command = "sleep 60"
  }
  triggers = {
    "before" = azuread_service_principal_password.sp_password.value
  }
}
