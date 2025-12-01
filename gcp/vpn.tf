##############################
# GCP NETWORK + CLOUD ROUTER #
##############################

# ---------------------------------------------------------
# AWS HA VPN GATEWAY + ROUTER
# ---------------------------------------------------------

resource "google_compute_ha_vpn_gateway" "ha_vpn_aws" {
  name    = "gcp-ha-vpn-aws"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router" "router_aws" {
  name    = "gcp-router-aws"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 65100
  }
}

###################################
# AWS EXTERNAL VPN GATEWAY (2 IF)
###################################

resource "google_compute_external_vpn_gateway" "aws" {
  name            = "aws-external-gw"
  redundancy_type = "TWO_IPS_REDUNDANCY"

  interface {
    id         = 0
    ip_address = "34.198.68.211"
  }

  interface {
    id         = 1
    ip_address = "34.230.218.47"
  }
}

###################
# AWS TUNNEL 1
###################

resource "google_compute_vpn_tunnel" "aws_tunnel_1" {
  name                  = "aws-tunnel-1"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn_aws.id
  vpn_gateway_interface = 0

  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 0

  shared_secret = var.psk

  router = google_compute_router.router_aws.id
}

resource "google_compute_router_interface" "aws_if_1" {
  name       = "aws-if-1"
  router     = google_compute_router.router_aws.name
  region     = var.region

  ip_range   = "169.254.180.129/30"
  vpn_tunnel = google_compute_vpn_tunnel.aws_tunnel_1.id
}

resource "google_compute_router_peer" "aws_bgp_peer_1" {
  name       = "aws-peer-1"
  router     = google_compute_router.router_aws.name
  region     = var.region

  interface       = google_compute_router_interface.aws_if_1.name
  peer_ip_address = "169.254.180.130"
  peer_asn        = 65020
  advertise_mode  = "DEFAULT"
}

###################
# AWS TUNNEL 2
###################

resource "google_compute_vpn_tunnel" "aws_tunnel_2" {
  name                  = "aws-tunnel-2"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn_aws.id
  vpn_gateway_interface = 1

  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 1

  shared_secret = var.psk

  router = google_compute_router.router_aws.id
}

resource "google_compute_router_interface" "aws_if_2" {
  name       = "aws-if-2"
  router     = google_compute_router.router_aws.name
  region     = var.region

  ip_range   = "169.254.180.133/30"
  vpn_tunnel = google_compute_vpn_tunnel.aws_tunnel_2.id
}

resource "google_compute_router_peer" "aws_bgp_peer_2" {
  name       = "aws-peer-2"
  router     = google_compute_router.router_aws.name
  region     = var.region

  interface       = google_compute_router_interface.aws_if_2.name
  peer_ip_address = "169.254.180.132"
  peer_asn        = 65020
  advertise_mode  = "DEFAULT"
}

# ---------------------------------------------------------
# AZURE HA VPN GATEWAY + ROUTER
# ---------------------------------------------------------

resource "google_compute_ha_vpn_gateway" "ha_vpn_azure" {
  name    = "gcp-ha-vpn-azure"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router" "router_azure" {
  name    = "gcp-router-azure"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 65110  # Un ASN distinto solo para separar el par (no afecta nada)
  }
}

####################################
# AZURE EXTERNAL VPN GATEWAY (1 IF)
####################################

resource "google_compute_external_vpn_gateway" "azure" {
  name            = "azure-external-gw"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"

  interface {
    id         = 0
    ip_address = var.azure_ip
  }
}

###################
# AZURE TUNNEL
###################

resource "google_compute_vpn_tunnel" "azure_tunnel" {
  name                  = "azure-tunnel"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn_azure.id
  vpn_gateway_interface = 0

  peer_external_gateway           = google_compute_external_vpn_gateway.azure.id
  peer_external_gateway_interface = 0

  shared_secret = var.psk

  router = google_compute_router.router_azure.id
}

resource "google_compute_router_interface" "azure_if" {
  name       = "azure-if"
  router     = google_compute_router.router_azure.name
  region     = var.region

  ip_range   = "169.254.21.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.azure_tunnel.id
}

resource "google_compute_router_peer" "azure_bgp_peer" {
  name            = "azure-peer"
  router          = google_compute_router.router_azure.name
  region          = var.region

  interface       = google_compute_router_interface.azure_if.name
  peer_ip_address = "169.254.21.1"
  peer_asn        = 65001
  advertise_mode  = "DEFAULT"
}
