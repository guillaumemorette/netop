# Output variable

output "subnet-id" {
value = azurerm_subnet.gw-subnet.id
}

output "vnet-name" {
value = azurerm_virtual_network.gw-vnet.name
}

output "vnet-id" {
value = azurerm_virtual_network.gw-vnet.id
}