# vnet gateway template

resource "azurerm_virtual_network" "gw-vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource-group
  address_space       = [var.vnet-cidr]
}

resource "azurerm_subnet" "gw-subnet" {
  name                 = var.name
  resource_group_name  = var.resource-group
  virtual_network_name = azurerm_virtual_network.gw-vnet.name
  address_prefix       = var.subnet-cidr
/*
  delegation {
    name = "vm-delegation"
    service_delegation {
      name = "Microsoft.BareMetal/AzureVMware"
      actions = ["Microsoft.Network/networkinterfaces/*","Microsoft.Network/virtualNetworks/subnets/action","Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }  
*/

}

