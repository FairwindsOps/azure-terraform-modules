variable "admin_username" {
  type        = string
  default     = "aksadmin"
  description = "The admin username set in the linux_profile"
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

## Default Node Pool Options
variable "node_count" {
  default     = 1
  description = "The default node pool instance count"
}

variable "enable_aad_auth" {
  default     = false
  description = "Enable Kubernetes API Azure AD authentication"
}

variable "enable_auto_scaling" {
  default     = true
  description = "Enable autoscaling on the default node pool"
}

variable "enable_rbac" {
  default     = true
  description = "Enable RBAC on the Kubernetes API"
}

variable "enable_node_public_ip" {
  default     = false
  description = "Enable public IPs on the default node pool"
}

variable "enable_http_application_routing" {
  default = false
}

variable "enable_kube_dashboard" {
  default = false
}

variable "enable_aci_connector_linux" {
  default = false
}

variable "enable_azure_policy" {
  default = false
}

variable "log_analytics_workspace_id" {
  default     = null
  description = "If set, this enables the OMS agent cluster addon"
}

variable "node_taints" {
  default     = null
  description = "Default node pool taints"
}

variable "os_disk_size_gb" {
  default     = 50
  description = "Default node pool disk size"
}

variable "node_min_count" {
  default     = 1
  description = "Default node pool intial count (used with autoscaling)"
}

variable "node_max_count" {
  default     = 10
  description = "Default node pool max count (use with autoscaling)"
}

variable "node_max_pods" {
  default     = 110
  description = "Total amount of pods allowed per node"
}

variable "node_type" {
  default     = "Standard_D2_v2"
  description = "The Azure VM instance type"
}

variable "node_availability_zones" {
  default     = [1, 2, 3]
  description = "The availability zones to place the node pool instances"
}

variable "docker_bridge_cidr" {
  description = "The CIDR to use for the docker network interface"
  default     = null
}

variable "managed_outbound_ip_count" {
  default = null
  type    = number
}

variable "outbound_ip_address_ids" {
  default = null
  type    = list(string)
}

variable "outbound_ip_prefix_ids" {
  default = null
  type    = list(string)
}

variable "outbound_ports_allocated" {
  default = 0
  type = number
}

variable "load_balancer_idle_timeout_in_minutes" {
  default = 30
  type = number
}

variable "kubernetes_version" {
  description = "The AKS Kubernetes version"
  default     = null
}

variable "load_balancer_sku" {
  type        = string
  description = "The load balancer type. Supported values: basic, standard"
  default     = "standard"
}

# https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#network_plugin
variable "network_plugin" {
  type        = string
  description = "The CNI network plugin to use (only azure, or kubenet)"
  default     = "kubenet"
}

# https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html#network_policy
variable "network_policy" {
  description = "The network polcy for the CNI. Only used when network_plugin is set to azure. Supported values: calico, azure"
  default     = null
}

variable "node_subnet_id" {
  type        = string
  description = "The subnet ID for default_node_pool"
}

variable "pod_cidr" {
  description = "The CIDR for the pod network"
  default     = null
}

variable "public_ssh_key_path" {
  type        = string
  description = "The path to the ssh pub file, tied to the admin user in linux_profile"
}

variable "region" {
  type        = string
  description = "Azure Region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to use"
}

variable "service_cidr" {
  description = "The CIDR for kubernetes services"
  default     = null
}

variable "aks_sp_secret" {
  type        = string
  default     = null
  description = "The secret to use for the AKS service principal account"
}

variable "auth_client_sp_secret" {
  type        = string
  default     = null
  description = "The secret to use for the AAD Client service principal account"
}

variable "auth_server_sp_secret" {
  type        = string
  default     = null
  description = "The secret to use for the AAD Server service principal account"
}

variable "additional_tags" {
  default = {}
}
