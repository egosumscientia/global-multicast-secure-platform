resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-multicloud-vgw"
  }
}

# -----------------------------
# Customer Gateway: Azure
# -----------------------------
resource "aws_customer_gateway" "cg_azure" {
  bgp_asn    = 65010
  ip_address = var.azure_ip      # IP pública del VPN Azure
  type       = "ipsec.1"

  tags = {
    Name = "aws-to-azure-cgw"
  }
}

# -----------------------------
# Customer Gateway: GCP
# -----------------------------
resource "aws_customer_gateway" "cg_gcp" {
  bgp_asn    = 65020
  ip_address = var.gcp_ip        # IP pública del VPN GCP
  type       = "ipsec.1"

  tags = {
    Name = "aws-to-gcp-cgw"
  }
}

# -----------------------------
# AWS ↔ Azure VPN Connection
# -----------------------------
resource "aws_vpn_connection" "vpn_aws_azure" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cg_azure.id
  type                = "ipsec.1"
  static_routes_only  = true

  # PSK para Azure (igual que en Azure para este túnel)
  tunnel1_preshared_key = var.psk_azure
  tunnel2_preshared_key = var.psk_azure
}

# -----------------------------
# AWS ↔ GCP VPN Connection
# -----------------------------
resource "aws_vpn_connection" "vpn_aws_gcp" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cg_gcp.id
  type                = "ipsec.1"
  static_routes_only  = true

  # PSK para GCP (igual que en Azure y GCP)
  tunnel1_preshared_key = var.psk_gcp
  tunnel2_preshared_key = var.psk_gcp
}

# -----------------------------
# Rutas estáticas AWS → Azure
# -----------------------------
resource "aws_vpn_connection_route" "route_aws_to_azure" {
  destination_cidr_block = var.azure_cidr   # antes hardcodeado
  vpn_connection_id      = aws_vpn_connection.vpn_aws_azure.id
}

# -----------------------------
# Rutas estáticas AWS → GCP
# -----------------------------
resource "aws_vpn_connection_route" "route_aws_to_gcp" {
  destination_cidr_block = var.gcp_cidr     # antes hardcodeado
  vpn_connection_id      = aws_vpn_connection.vpn_aws_gcp.id
}
