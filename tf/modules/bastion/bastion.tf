

resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource-group
  virtual_network_name = var.vnet-name
  address_prefix       = var.subnet-prefix
}

resource "azurerm_public_ip" "pip" {
  name                = "bastion-pip"
  location            = var.location
  resource_group_name = var.resource-group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "Bastion"
  location            = var.location
  resource_group_name = var.resource-group

  ip_configuration {
    name                 = "ip-config"
    subnet_id            = azurerm_subnet.bastion-subnet.id
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

