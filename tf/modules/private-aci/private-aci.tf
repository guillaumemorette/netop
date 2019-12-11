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
    commands = ["/bin/bash"]

  }

  network_profile_id = azurerm_network_profile.netop-np.id

}

