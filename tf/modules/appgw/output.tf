# outputs

output "public-ip" {
  value = azurerm_public_ip.public-fe.ip_address
} 

output "subnet-id" {
  value = azurerm_subnet.gw-subnet.id
}
