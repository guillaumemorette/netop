### POC New Network Topology ###

provider "azurerm" {
  version = "1.37"
}

resource "azurerm_resource_group" "poc-netop-rg" {
  name     = "poc-netop-rg"
  location = var.location
}


#### APID RESOURCES ###

module "vnet-apid" {
  source = "./modules/vnet-aci"
  name = "apid"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-cidr = "10.1.0.0/16"
  subnet-cidr = "10.1.1.0/24"
  location = var.location
}

module "apid-aci" {
  source = "./modules/private-aci"
  name = "apid-aci"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  location = var.location
  subnet-id = module.vnet-apid.subnet-id
  container-name = "helloworld"
  container-image = "mcr.microsoft.com/azuredocs/aci-helloworld"
  container-cpu = "0.5"
  container-memory = "1.5"
}

module "appgw-apid" {
  source = "./modules/appgw"
  name = "apid-gw"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  location = var.location
  vnet-name = module.vnet-apid.vnet-name
  subnet-cidr = "10.1.2.0/28"
  fe-private-ip = "10.1.2.10"
  listener = "public"
  backend-ip = module.apid-aci.ip-address
}


#### AFA RESOURCES ####
/*
module "vnet-vm" {
  source = "./modules/vnet-vm"
  name = "AFA"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-cidr = "10.1.0.0/16"
  subnet-cidr = "10.1.1.0/24"
  location = var.location
}

module "vm" {
  source = "./modules/vm"
  prefix = "AFA"
  location = var.location
  resource-group = azurerm_resource_group.poc-netop-rg.name
  subnet-id = module.vnet-vm.subnet-id
}
*/




