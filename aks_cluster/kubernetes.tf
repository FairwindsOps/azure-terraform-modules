# Role assignment

# Use ADMIN credentials
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.cluster.kube_admin_config.0.host
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.cluster.kube_admin_config.0.cluster_ca_certificate)}"
  load_config_file       = false
}

# Create cluster role binding to the clusteradmin AAD group

resource "kubernetes_cluster_role_binding" "aad_integration" {
  metadata {
    name = "${var.cluster_name}-aad-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind = "Group"
    name = azuread_group.aks-aad-clusteradmins.id
  }
  depends_on = [
    azurerm_kubernetes_cluster.cluster
  ]
}