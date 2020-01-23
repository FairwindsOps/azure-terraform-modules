variable "admin_username" {
  type        = string
  default     = "admin"
  description = "The admin username set in the linux_profile"
}

variable "public_ssh_key_path" {
  type        = string
  description = "The path to the ssh pub file, tied to the admin user in linux_profile"
}

variable "region" {
  type        = string
  description = "Azure Region"
}

variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to use"
}

variable "tags" {
  default = {}
}

variable "service_principal_secret" {
  type        = string
  description = "The secret to use for the service principal account"
}

variable "kubernetes_version" {
  description = "The AKS Kubernetes version"
  default     = null
}

variable "vnet_subnet_id" {
  type        = string
  description = "The subnet ID for default_node_pool"
}

variable "default_node_pool" {
  description = "Default node pool map"
  default = {
    node_count            = 1
    enable_auto_scaling   = true
    enable_node_public_ip = false
    node_taints           = null
    os_disk_size_gb       = 35
    min_count             = 1
    max_count             = 20
    max_pods              = 200
    vm_size               = "Standard_D2_v2"
    availability_zones    = [1, 2, 3]
  }
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

variable "load_balancer_sku" {
  type        = string
  description = "The load balancer type. Supported values: basic, standard"
  default     = "standard"
}

variable "docker_bridge_cidr" {
  description = "The CIDR to use for the docker network interface"
  default     = null
}

variable "pod_cidr" {
  description = "The CIDR for the pod network"
  default     = null
}

variable "service_cidr" {
  description = "The CIDR for kubernetes services"
  default     = null
}
