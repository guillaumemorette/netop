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
  vnet-cidr = var.apid-vnet-cidr
  subnet-cidr = var.apid-subnet-cidr
  location = var.location
}

module "apid-aci" {
  source = "./modules/private-aci"
  name = "apid-aci"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  location = var.location
  subnet-id = module.vnet-apid.subnet-id
  appgw-fe-private-ip = var.apid-appgw-private-ip
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
  subnet-cidr = var.apid-appgw-subnet-cidr
  fe-private-ip = var.apid-appgw-private-ip
  listener = "public"
  backend-ips = [module.apid-aci.ip-address]
  backend-fqdns = null
  target-host = var.apid-target-host
}

#### AFA RESOURCES ####

module "vnet-afa" {
  source = "./modules/vnet-vm"
  name = "afa"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-cidr = var.afa-vnet-cidr
  subnet-cidr = var.afa-subnet-cidr
  location = var.location
}

module "vm" {
  source = "./modules/vm"
  prefix = "afa"
  location = var.location
  resource-group = azurerm_resource_group.poc-netop-rg.name
  subnet-id = module.vnet-afa.subnet-id
}

module "appgw-afa" {
  source = "./modules/appgw"
  name = "afa-gw"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  location = var.location
  vnet-name = module.vnet-afa.vnet-name
  subnet-cidr = var.afa-appgw-subnet-cidr
  fe-private-ip = var.afa-appgw-private-ip
  listener = "private"
  backend-ips = [module.appgw-apid.public-ip]
  backend-fqdns = null 
  target-host = var.apid-target-host
}


module "afa-dns" {
  source = "./modules/dns-zone"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-id = module.vnet-afa.vnet-id
  dns-zone-name = var.afa-dns-zone-name
  dns-record-name = var.afa-dns-record-name
  dns-record-ip = var.afa-appgw-private-ip
}
