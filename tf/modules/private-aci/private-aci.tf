# Main private-aci

resource "azurerm_network_profile" "netop-np" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource-group

  container_network_interface {
    name = var.name

    ip_configuration {
      name      = var.name
      subnet_id = var.subnet-id
    }
  }
}

resource "azurerm_container_group" "netop-aci" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource-group
  ip_address_type     = "private"
  os_type             = "Linux"


  container {
    name   = var.container-name
    image  = var.container-image
    cpu    = var.container-cpu
    memory = var.container-memory
    
    ports {
      port     = 80
      protocol = "TCP"
    }
  
  }

  container {
    name   = var.sidecar-name
    image  = var.sidecar-image
    cpu    = var.sidecar-cpu
    memory = var.sidecar-memory

    ports {
      port     = 443
      protocol = "TCP"
    }
 
    volume {
      name = var.sidecar-volume-name
      mount_path = var.sidecar-volume-mount-path
      storage_account_name = var.sidecar-volume-sa-name
      storage_account_key = var.sidecar-volume-sa-key
      share_name = var.sidecar-volume-share-name
    }

  }
  

  network_profile_id = azurerm_network_profile.netop-np.id

}

resource "azurerm_network_security_group" "aci-sg" {
  name                = "aci-appgw-sg"
  location            = var.location
  resource_group_name = var.resource-group

  security_rule {
    name                       = "AllowFromAppGateway"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.appgw-fe-private-ip
    destination_address_prefix = azurerm_container_group.netop-aci.ip_address
  }

  security_rule {
    name                       = "AllowFromAppGatewaySSL"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.appgw-fe-private-ip
    destination_address_prefix = azurerm_container_group.netop-aci.ip_address
  }
}

resource "azurerm_subnet_network_security_group_association" "aci-sg-association" {
  subnet_id                 = var.subnet-id
  network_security_group_id = azurerm_network_security_group.aci-sg.id
 }


