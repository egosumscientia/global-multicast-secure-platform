resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-multicloud-vgw"
  }
}

resource "aws_customer_gateway" "cg_azure" {
  bgp_asn    = 65010
  ip_address = var.azure_ip
  type       = "ipsec.1"

  tags = {
    Name = "aws-to-azure-cgw"
  }
}

resource "aws_customer_gateway" "cg_gcp" {
  bgp_asn    = 65020
  ip_address = var.gcp_ip
  type       = "ipsec.1"

  tags = {
    Name = "aws-to-gcp-cgw"
  }
}

resource "aws_vpn_connection" "vpn_aws_azure" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cg_azure.id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_preshared_key = var.psk_aws
  tunnel2_preshared_key = var.psk_aws
}

resource "aws_vpn_connection" "vpn_aws_gcp" {
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  customer_gateway_id = aws_customer_gateway.cg_gcp.id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_preshared_key = var.psk_gcp
  tunnel2_preshared_key = var.psk_gcp
}

resource "aws_vpn_connection_route" "route_aws_to_azure" {
  destination_cidr_block = var.azure_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_aws_azure.id
}

resource "aws_vpn_connection_route" "route_aws_to_gcp" {
  destination_cidr_block = var.gcp_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_aws_gcp.id
}
