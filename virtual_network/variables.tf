variable "name" {
  description = "Name of the network"
}

variable "network_cidr_prefix" {
  type    = string
  default = "10.0.0.0"
}

variable "network_cidr_suffix" {
  type        = number
  default     = 8
  description = "The cidr block size for the network"
}

variable "subnets" {
  type = list(object({
    name       = string
    cidr_block = number
  }))
  default = [
    {
      name       = "subnet-1"
      cidr_block = 18
    },
    {
      name       = "subnet-2"
      cidr_block = 18
    }
  ]
  description = "A list of objects describing requested subnetwork prefixes. cidr_block is the size of the network."
}

variable "region" {
  description = "Azure Region"
}

variable "resource_group_name" {
  type = string
}

variable "additional_tags" {
  default = {}
}

variable "enable_ddos_protection_plan" {
  default = false
  type = bool
}

variable "ddos_protection_plan_id" {
  default = null
  type = string
}
