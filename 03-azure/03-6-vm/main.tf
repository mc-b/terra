data "azurerm_resource_group" "main" {
  name = "${var.name_prefix}-rg"
}
resource "azurerm_virtual_network" "example" {
  name                = "${var.name_prefix}-vnet"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.common_tags
}

resource "azurerm_subnet" "example" {
  name                 = "${var.name_prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "${var.name_prefix}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = var.common_tags
}

resource "azurerm_public_ip" "example" {
  name                = "${var.name_prefix}-pip"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_network_interface" "example" {
  name                = "${var.name_prefix}-nic"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }

  tags = var.common_tags
}

resource "azurerm_linux_virtual_machine" "example" {
  name                            = "${var.name_prefix}-vm"
  resource_group_name             = data.azurerm_resource_group.main.name
  location                        = data.azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  admin_password                  = "M1cr0s0ft%insecure"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro-gen1"
    version   = "latest"
  }

  tags = merge(var.common_tags, {
    Name = "${var.name_prefix}-vm"
  })
}