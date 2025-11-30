resource "azurerm_resource_group" "rg" {
  name     = "rg-multicloud"
  location = "eastus"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-multicloud"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-main"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.20.1.0/24"]
}
