# Generate random string to get unique Storage account name
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
}

# Create Azure Storage account
resource "azurerm_storage_account" "CorpStorage01" {
  name                     = "itrastorage${random_string.random.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  # Enable cool access tier to reduce storage access costs
  access_tier              = "Cool"
  # Enable maximum available redundancy level for this account
  account_replication_type = "GRS"
}

# Create a share for drive mapping in Windows VM
resource "azurerm_storage_share" "BackupShare" {
  name                 = "backup"
  quota                = 5
  storage_account_name = azurerm_storage_account.CorpStorage01.name
  depends_on           = [azurerm_storage_account.CorpStorage01]
}

# Create a blob container
resource "azurerm_storage_container" "BlobContainer" {
  name                  = "blobcontainer"
  storage_account_name  = azurerm_storage_account.CorpStorage01.name
  container_access_type = "private"
}

# Add network security rules for storage account
resource "azurerm_storage_account_network_rules" "storage_net_rules" {
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.CorpStorage01.name
  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  ip_rules                   = ["185.176.222.0/24"]
  virtual_network_subnet_ids = [azurerm_subnet.storage_subnet.id]
}