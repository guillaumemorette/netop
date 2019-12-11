# outputs

output "public-ip" {
  value = azurerm_public_ip.public-fe.ip_address
} 
