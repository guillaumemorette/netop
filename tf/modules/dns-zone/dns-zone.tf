# DNS Zone template

resource "azurerm_private_dns_zone" "dns-zone" {
  name                = var.dns-zone-name
  resource_group_name = var.resource-group
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  name                  = join("-",[var.dns-zone-name,"link"])
  resource_group_name   = var.resource-group
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  virtual_network_id    = var.vnet-id
}

resource "azurerm_private_dns_a_record" "dns-record" {
  name                = var.dns-record-name
  zone_name           = azurerm_private_dns_zone.dns-zone.name
  resource_group_name = var.resource-group
  ttl                 = 300
  records             = [var.dns-record-ip]
}
