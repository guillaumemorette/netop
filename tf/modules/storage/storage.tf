
resource "azurerm_storage_account" "nginx" {
  name                     = var.storage-name
  resource_group_name      = var.resource-group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "nginx" {
  name                 = var.share-name
  storage_account_name = azurerm_storage_account.nginx.name
  quota                = 1

  provisioner "local-exec" {
    working_dir = "/home/morette/poc/netop/project/scripts"
    command = "./set_nginx_files.sh ${var.storage-name} ${azurerm_storage_account.nginx.primary_access_key} ${var.share-name}"
  } 

}

