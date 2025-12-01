##############################
# GCP NETWORK + CLOUD ROUTER #
##############################

resource "google_compute_ha_vpn_gateway" "ha_vpn" {
  name    = "gcp-ha-vpn"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  name    = "gcp-router"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 65010
  }
}

###################################
# AWS EXTERNAL VPN GATEWAY (2 IF) #
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

####################################
# AZURE EXTERNAL VPN GATEWAY (1 IF)#
####################################

resource "google_compute_external_vpn_gateway" "azure" {
  name            = "azure-external-gw"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"

  interface {
    id         = 0
    ip_address = "172.190.184.73"
  }
}

###################
# AWS TUNNEL 1    #
###################

resource "google_compute_vpn_tunnel" "aws_tunnel_1" {
  name                  = "aws-tunnel-1"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn.id
  vpn_gateway_interface = 0

  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 0

  shared_secret = var.psk
}

# BGP sobre AWS TUNNEL 1 (rango asumido /30, ajusta si en AWS es otro)
resource "google_compute_router_interface" "aws_if_1" {
  name       = "aws-if-1"
  router     = google_compute_router.router.name
  region     = var.region

  ip_range   = "169.254.180.129/30"   # GCP: 169.254.180.129, AWS: 169.254.180.130
  vpn_tunnel = google_compute_vpn_tunnel.aws_tunnel_1.id
}

resource "google_compute_router_peer" "aws_bgp_peer_1" {
  name       = "aws-peer-1"
  router     = google_compute_router.router.name
  region     = var.region
  interface  = google_compute_router_interface.aws_if_1.name

  peer_ip_address = "169.254.180.130" # IP BGP lado AWS (túnel 1)
  peer_asn        = 65020             # ASN AWS
  advertise_mode  = "DEFAULT"
}

###################
# AWS TUNNEL 2    #
###################

resource "google_compute_vpn_tunnel" "aws_tunnel_2" {
  name                  = "aws-tunnel-2"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn.id
  vpn_gateway_interface = 1

  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 1

  shared_secret = var.psk
}

# BGP sobre AWS TUNNEL 2 (IPs según tu config anterior)
resource "google_compute_router_interface" "aws_if_2" {
  name       = "aws-if-2"
  router     = google_compute_router.router.name
  region     = var.region

  ip_range   = "169.254.180.133/30"   # GCP: 169.254.180.133, AWS: 169.254.180.132
  vpn_tunnel = google_compute_vpn_tunnel.aws_tunnel_2.id
}

resource "google_compute_router_peer" "aws_bgp_peer_2" {
  name       = "aws-peer-2"
  router     = google_compute_router.router.name
  region     = var.region
  interface  = google_compute_router_interface.aws_if_2.name

  peer_ip_address = "169.254.180.132" # IP BGP lado AWS (túnel 2)
  peer_asn        = 65020             # ASN AWS
  advertise_mode  = "DEFAULT"
}

###################
# AZURE TUNNEL    #
###################

resource "google_compute_vpn_tunnel" "azure_tunnel" {
  name                  = "azure-tunnel"
  region                = var.region

  vpn_gateway           = google_compute_ha_vpn_gateway.ha_vpn.id
  vpn_gateway_interface = 0

  peer_external_gateway           = google_compute_external_vpn_gateway.azure.id
  peer_external_gateway_interface = 0

  shared_secret = var.psk
}

# BGP sobre AZURE TUNNEL (IPs según tu config)
resource "google_compute_router_interface" "azure_if" {
  name       = "azure-if"
  router     = google_compute_router.router.name
  region     = var.region

  ip_range   = "10.20.255.29/30"      # GCP: 10.20.255.29, Azure: 10.20.255.30
  vpn_tunnel = google_compute_vpn_tunnel.azure_tunnel.id
}

resource "google_compute_router_peer" "azure_bgp_peer" {
  name       = "azure-peer"
  router     = google_compute_router.router.name
  region     = var.region
  interface  = google_compute_router_interface.azure_if.name

  peer_ip_address = "10.20.255.30"    # IP BGP lado Azure
  peer_asn        = 65515             # ASN Azure
  advertise_mode  = "DEFAULT"
}
