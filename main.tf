provider: azurerm{
  features{}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  resource_group_name = var.resourcesrg
  location            = var.location
  address_space       = ["10.0.0.0/16"]

    tags = {
        environment = "Production"
    }

    resource "azurerm_windows_virtual_machine" "vm" {
        name                  = "vm"
        resource_group_name   = azurerm_resource_group.rg.name
        location              = azurerm_resource_group.rg.location
        size                  = "Standard_F2"
        admin_username        = "adminuser"
        admin_password        = "Password1234!"
        network_interface_ids = [azurerm_network_interface.nic.id]
        os_disk {
            caching              = "ReadWrite"
            storage_account_type = "Standard_LRS"
        }

        source_image_reference {
            publisher = "MicrosoftWindowsServer"
            offer     = "WindowsServer"
            sku       = "2019-Datacenter"
            version   = "latest"
        }

        tags = {
            environment = "Production"
        }
    }

    resource "azurerm_network_interface" "nic" {
        name                = "nic"
        resource_group_name = azurerm_resource_group.rg.name
        location            = azurerm_resource_group.rg.location

        ip_configuration {
            name                          = "nicConfiguration"
            subnet_id                     = azurerm_subnet.subnet.id
            private_ip_address_allocation = "Dynamic"
        }
    }

