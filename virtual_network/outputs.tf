# VPC Details

output "id" {
  value = azurerm_virtual_network.network.id
}
output "name" {
  value = azurerm_virtual_network.network.name
}

output "subnets" {
  value = azurerm_virtual_network.network.subnet.*.id
}
