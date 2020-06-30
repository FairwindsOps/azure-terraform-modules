variable "node_count" {
  type        = number
  description = "The initial node pool size"
  default     = 1
}

variable "name" {
  type        = string
  description = "Name of the node pool"
}

variable "aks_cluster_id" {
  type        = string
  description = "The ID of the AKS cluster"
}

variable "enable_auto_scaling" {
  description = "Boolean that configures cluster autoscaling"
  default     = false
}

variable "enable_node_public_ip" {
  description = "Boolean that enables public IP addresses to nodes"
  default     = false
}

variable "node_taints" {
  type        = list(string)
  description = "A list containing taints to apply to the Kubernetes node"
  default     = null
}

variable "os_disk_size_gb" {
  type        = number
  description = "The root disk size for the node"
  default     = 35
}

variable "min_count" {
  type        = number
  description = "Minimum amount of nodes in the pool, if autoscaling enabled. This is overridden if enable_autoscaling is true, but this variable is unset"
  default     = null
}

variable "max_count" {
  type        = number
  description = "Max amount of nodes in the pool, if autoscaling enabled. This is overridden if enable_autoscaling is true, but this variable is unset"
  default     = null
}

variable "max_pods" {
  type        = number
  description = "The max amount of pods allowed to run on a node. Dependent on CNI."
  default     = 200
}

variable "os_type" {
  type        = string
  description = "Linux or Windows"
  default     = "Linux"
}

variable "vm_size" {
  type        = string
  description = "Azure VM instance type"
  default     = "Standard_D2_v2"
}

variable "node_subnet_id" {
  type        = string
  description = "The subnet to place this node pool"
}

variable "availability_zones" {
  type        = list(number)
  description = "The availablility zones to place the nodes. Dependent on selected region"
  default     = [1, 2, 3]
}

variable "kubernetes_version" {
  type = string
  description = "The Kubernetes version the node pool will use."
}
