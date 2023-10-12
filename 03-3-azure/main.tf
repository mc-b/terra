provider "azurerm" {
  features {}
}

# Ressource Gruppe

resource "azurerm_resource_group" "webshop" {
  name     = "webshop"
  location = var.location
}

# Netzwerk

resource "azurerm_virtual_network" "webshop" {
  name                = "webshop-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.webshop.location
  resource_group_name = azurerm_resource_group.webshop.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.webshop.name
  virtual_network_name = azurerm_virtual_network.webshop.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "webshop-pip"
  resource_group_name = azurerm_resource_group.webshop.name
  location            = azurerm_resource_group.webshop.location
  allocation_method   = "Dynamic"
}

#######################################
# VM Informationen Webshop

resource "azurerm_network_interface" "webshop" {
  name                = "webshop-nic1"
  resource_group_name = azurerm_resource_group.webshop.name
  location            = azurerm_resource_group.webshop.location

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "internal" {
  name                      = "webshop-nic2"
  resource_group_name       = azurerm_resource_group.webshop.name
  location                  = azurerm_resource_group.webshop.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Security 

resource "azurerm_network_security_group" "webshop" {
  name                = "webshop-nsg"
  location            = azurerm_resource_group.webshop.location
  resource_group_name = azurerm_resource_group.webshop.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "http"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "80"
    destination_address_prefix = azurerm_network_interface.webshop.private_ip_address
  }
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 200
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.webshop.private_ip_address
  }  
}

resource "azurerm_network_interface_security_group_association" "webshop" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.webshop.id
}

# VM 

resource "azurerm_linux_virtual_machine" "webshop" {
  name                              = "webshop"
  resource_group_name               = azurerm_resource_group.webshop.name
  location                          = azurerm_resource_group.webshop.location
  size                              = "Standard_B1ls"
  admin_username                    = "ubuntu"
  admin_password                    = "P@ssw0rd1234!"
  disable_password_authentication   = false  
  custom_data                       = base64encode(data.template_file.webshop.rendered)
  network_interface_ids             = [azurerm_network_interface.webshop.id, azurerm_network_interface.internal.id]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

#######################################
# VM Informationen Order

resource "azurerm_network_interface" "order" {
  name                      = "order-nic1"
  resource_group_name       = azurerm_resource_group.webshop.name
  location                  = azurerm_resource_group.webshop.location
  internal_dns_name_label   = "order"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM 

resource "azurerm_linux_virtual_machine" "order" {
  name                              = "order"
  resource_group_name               = azurerm_resource_group.webshop.name
  location                          = azurerm_resource_group.webshop.location
  size                              = "Standard_B1ls"
  admin_username                    = "ubuntu"
  admin_password                    = "P@ssw0rd1234!"
  disable_password_authentication   = false  
  custom_data                       = base64encode(data.template_file.order.rendered)
  network_interface_ids             = [azurerm_network_interface.order.id]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}


#######################################
# VM Informationen catalog

resource "azurerm_network_interface" "catalog" {
  name                      = "catalog-nic1"
  resource_group_name       = azurerm_resource_group.webshop.name
  location                  = azurerm_resource_group.webshop.location
  internal_dns_name_label   = "catalog"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM 

resource "azurerm_linux_virtual_machine" "catalog" {
  name                              = "catalog"
  resource_group_name               = azurerm_resource_group.webshop.name
  location                          = azurerm_resource_group.webshop.location
  size                              = "Standard_B1ls"
  admin_username                    = "ubuntu"
  admin_password                    = "P@ssw0rd1234!"
  disable_password_authentication   = false  
  custom_data                       = base64encode(data.template_file.catalog.rendered)
  network_interface_ids             = [azurerm_network_interface.catalog.id]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}


#######################################
# VM Informationen customer

resource "azurerm_network_interface" "customer" {
  name                      = "customer-nic1"
  resource_group_name       = azurerm_resource_group.webshop.name
  location                  = azurerm_resource_group.webshop.location
  internal_dns_name_label   = "customer"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# VM 

resource "azurerm_linux_virtual_machine" "customer" {
  name                              = "customer"
  resource_group_name               = azurerm_resource_group.webshop.name
  location                          = azurerm_resource_group.webshop.location
  size                              = "Standard_B1ls"
  admin_username                    = "ubuntu"
  admin_password                    = "P@ssw0rd1234!"
  disable_password_authentication   = false  
  custom_data                       = base64encode(data.template_file.customer.rendered)
  network_interface_ids             = [azurerm_network_interface.customer.id]

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
