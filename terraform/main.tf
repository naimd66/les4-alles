# Terraform configuration for deploying 2 Ubuntu VMs and writing to Ansible inventory

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  default = "S1202816"
}

variable "location" {
  default = "westeurope"
}

variable "admin_username" {
  default = "iac"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "vm_count" {
  default = 2
}

# Get existing resource group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "iac-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "iac-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IPs
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "iac-pip-${count.index}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Network Interfaces
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "iac-nic-${count.index}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }
}

# Linux VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "iac-vm-${count.index}"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.main.name
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    name                 = "osdisk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Output to inventory file for Ansible
resource "local_file" "ansible_inventory" {
  content = <<EOT
[webserver]
${azurerm_public_ip.pip[0].ip_address} ansible_user=${var.admin_username}

[dbserver]
${azurerm_public_ip.pip[1].ip_address} ansible_user=${var.admin_username} db_user=dbuser db_password=dbpassword
EOT
  filename = "${path.module}/../inventories/hosts"
}
