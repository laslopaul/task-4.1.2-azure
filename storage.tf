# Generate random string to get unique Storage account name
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
}

# Create Azure Storage account
resource "azurerm_storage_account" "CorpStorage01" {
  name                     = "itrastorage-${random_string.random.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  access_tier              = "Cool"
  account_replication_type = "GRS"

  network_rules {
      default_action = "Deny"
      virtual_network_subnet_ids = [azurerm_subnet.storage_subnet.id]
  }

}

# Create a share for drive mapping in Windows VM
resource "azurerm_storage_share" "BackupShare" {
  name                 = "backup"
  quota                = 1024
  storage_account_name = azurerm_storage_account.CorpStorage01.name
  depends_on           = [azurerm_storage_account.CorpStorage01]
}
