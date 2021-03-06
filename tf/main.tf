### POC New Network Topology ###

provider "azurerm" {
  version = "1.40"
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
  sidecar-name = "nginx"
  sidecar-image = "nginx"
  sidecar-cpu = "1.0"
  sidecar-memory = "1.5"
  sidecar-volume-name = "nginx-config"
  sidecar-volume-mount-path = "/etc/nginx"
  sidecar-volume-sa-name = var.apid-storage-account-name
  sidecar-volume-sa-key = module.storage-apid.access-key
  sidecar-volume-share-name = var.apid-storage-share-name
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
  pfx-certificate = "scripts/ssl.pfx"
  pfx-password = "dacloud"
  target-host = var.apid-target-host
  backend-ca-certificate = "ssl/rootCA.crt"
  probe-hostname = var.apid-target-host
}

module "storage-apid" {
  source = "./modules/storage"
  location = var.location
  resource-group = azurerm_resource_group.poc-netop-rg.name
  storage-name = var.apid-storage-account-name
  share-name = var.apid-storage-share-name
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

module "bastion" {
  source = "./modules/bastion"
  location = var.location
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-name = module.vnet-afa.vnet-name
  subnet-prefix = var.afa-bastion-cidr
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
  pfx-certificate = "ssl/*.vnet-tribe.afa.azure.extraxa.pfx"
  pfx-password = "dacloud"
  target-host = var.apid-target-host
  backend-ca-certificate = "ssl/rootCA.crt"
  probe-hostname = "hello.aci1.apid.vnet-tribe.afa.azure.extraxa"
}

module "afa-dns" {
  source = "./modules/dns-zone"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  vnet-id = module.vnet-afa.vnet-id
  dns-zone-name = var.afa-dns-zone-name
  dns-record-name = var.afa-dns-record-name
  dns-record-ip = var.afa-appgw-private-ip
}

module "firewall" {
  source = "./modules/nsg"
  resource-group = azurerm_resource_group.poc-netop-rg.name
  location = var.location
  gw-ip-address = module.appgw-afa.public-ip
  subnet-id = module.appgw-apid.subnet-id
}
