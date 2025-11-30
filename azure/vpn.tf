resource "azurerm_public_ip" "vpn_ip" {
  name                = "azure-vpn-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "gw" {
  name                = "azure-vpn-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  sku = "VpnGw1"

  ip_configuration {
    name                          = "vpngw-ipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet.id
  }
}

# -----------------------------
# Local Network Gateway: AWS
# -----------------------------
resource "azurerm_local_network_gateway" "aws" {
  name                = "aws-local-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  gateway_address = var.aws_ip          # IP pública del VPN AWS
  address_space   = [var.aws_cidr]      # 10.10.0.0/16
}

# -----------------------------
# Local Network Gateway: GCP
# -----------------------------
resource "azurerm_local_network_gateway" "gcp" {
  name                = "gcp-local-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  gateway_address = var.gcp_ip          # IP pública del VPN GCP
  address_space   = [var.gcp_cidr]      # 10.30.0.0/16
}

# -----------------------------
# Conexión Azure ↔ AWS
# -----------------------------
resource "azurerm_virtual_network_gateway_connection" "conn_azure_aws" {
  name                = "conn-azure-aws"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.aws.id

  shared_key = var.psk_aws   # PSK para AWS
}

# -----------------------------
# Conexión Azure ↔ GCP
# -----------------------------
resource "azurerm_virtual_network_gateway_connection" "conn_azure_gcp" {
  name                = "conn-azure-gcp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gw.id
  local_network_gateway_id   = azurerm_local_network_gateway.gcp.id

  shared_key = var.psk_gcp   # PSK para GCP
}
