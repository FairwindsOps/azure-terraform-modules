# VPC Details

output "id" {
  value = azurerm_virtual_network.network.id
}
output "name" {
  value = azurerm_virtual_network.network.name
}

output "subnet_ids" {
  value = azurerm_virtual_network.network.subnet.*.id
}

output "subnet_map" {
  value = [for i, n in var.subnets : {
    name = n.name
    id   = element(azurerm_virtual_network.network.subnet.*.id, i)
  }]
}
