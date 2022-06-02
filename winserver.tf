# ----Windows Server VM CONFIGURATION FILE----

# Create frontend network interface
resource "azurerm_network_interface" "nic_winvm" {
  name                = "NIC_WinVM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.storage_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip_winvm.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic_winvm.id
  network_security_group_id = azurerm_network_security_group.nsg_winvm.id
}

# Create virtual machine
resource "azurerm_windows_virtual_machine" "winvm" {
  name                  = "WinVM"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic_winvm.id]
  size                  = "Standard_B1s"
  admin_username        = "sysad"
  admin_password        = "itra_task412"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

}