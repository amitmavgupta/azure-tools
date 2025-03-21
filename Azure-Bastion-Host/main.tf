
# Create Resource Group
resource "azurerm_resource_group" "azurebastion" {
  name     = "azurevm"
  location = "canadacentral"
}

# Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "azure-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azurebastion.location
  resource_group_name = azurerm_resource_group.azurebastion.name
}

# Create Subnet for Azure Bastion
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.azurebastion.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create Public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_pip" {
  name                = "azure-bastion-pip"
  location            = azurerm_resource_group.azurebastion.location
  resource_group_name = azurerm_resource_group.azurebastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create Azure Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                = "azure-bastion"
  location            = azurerm_resource_group.azurebastion.location
  resource_group_name = azurerm_resource_group.azurebastion.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
