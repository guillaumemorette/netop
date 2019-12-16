
resource "azurerm_network_security_group" "nsg" {
  name                = "netop-nsg"
  location            = var.location
  resource_group_name = var.resource-group

  security_rule {
    name                       = "allow-afa-gw"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.gw-ip-address
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-azure-admin"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  

}

resource "azurerm_subnet_network_security_group_association" "association" {
  subnet_id                 = var.subnet-id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
