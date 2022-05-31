# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "RG_TASK_412"
  location = "japaneast"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet0" {
  name                = "VirtualNet412"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet for access to Azure Storage
resource "azurerm_subnet" "storage_subnet" {
  name                 = "StorageSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Create public IP for VMLUE01
resource "azurerm_public_ip" "publicip_winvm" {
  name                = "PublicIP_WinVM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}
