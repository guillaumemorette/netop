
# Application Gateway

/*
 * The dedicated application gateway subnet
 */
resource "azurerm_subnet" "gw-subnet" {
  name                 = var.name
  resource_group_name  = var.resource-group
  virtual_network_name = var.vnet-name
  address_prefix       = var.subnet-cidr
}

/*
 * The Public IP front end
 */
resource "azurerm_public_ip" "public-fe" {
  name                = join("-", [var.name,"pip"])
  resource_group_name = var.resource-group
  location            = var.location
  allocation_method   = "Static"
  sku		              = "Standard"
}

locals {
  listener-name = join("-", [var.name,"listener"])
}

resource "azurerm_application_gateway" "network" {

  name                = join("-", [var.name,"appgateway"])
  resource_group_name = var.resource-group
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }
  
  gateway_ip_configuration {
    name      = join("-", [var.name,"ip-configuration"])
    subnet_id = azurerm_subnet.gw-subnet.id
  }

  frontend_port {
    name = "FrontEnd-Port"
    port = 80
  }

  frontend_ip_configuration {
    name                          = "ingress-ip-config"
    public_ip_address_id          = var.listener == "public" ? azurerm_public_ip.public-fe.id : ""
    private_ip_address            = var.listener == "private" ? var.fe-private-ip : ""
    subnet_id		                  = var.listener == "private" ? azurerm_subnet.gw-subnet.id : ""
    private_ip_address_allocation = var.listener == "private" ? "Static" : "Dynamic"
  }

  frontend_ip_configuration {
    name                          = "egress-ip-config"
    public_ip_address_id          = var.listener == "private" ? azurerm_public_ip.public-fe.id : ""
    private_ip_address            = var.listener == "public" ? var.fe-private-ip : ""
    subnet_id		                  = var.listener == "public" ? azurerm_subnet.gw-subnet.id : ""
    private_ip_address_allocation = var.listener == "public" ? "Static" : "Dynamic"
  }

  /* One block per backend */
  backend_address_pool {
    name         = "BackendIP"
    ip_addresses = [var.backend-ip]
  }

  backend_http_settings {
    name                  = "BackendHTTPSettings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 5
  }

  http_listener {
    name                           = local.listener-name
    frontend_ip_configuration_name = "ingress-ip-config"
    frontend_port_name             = "FrontEnd-Port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = join("-", [var.name,"routing_rule"])
    rule_type                  = "Basic"
    http_listener_name         = local.listener-name
    backend_address_pool_name  = "BackendIP"
    backend_http_settings_name = "BackendHTTPSettings"
  }


}
