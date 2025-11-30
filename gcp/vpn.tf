resource "google_compute_router" "router" {
  name    = "gcp-router"
  region  = var.region
  network = google_compute_network.vpc.id

  bgp {
    asn = 65030
  }
}

resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "gcp-vpn-gateway"
  region  = var.region
  network = google_compute_network.vpc.id
}

resource "google_compute_vpn_tunnel" "tunnel_aws" {
  name          = "gcp-aws-tunnel"
  region        = var.region
  vpn_gateway   = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip       = var.aws_ip
  shared_secret = var.psk
  router        = google_compute_router.router.id

  local_traffic_selector  = [var.subnet_cidr]
  remote_traffic_selector = [var.aws_cidr]
}

resource "google_compute_vpn_tunnel" "tunnel_azure" {
  name          = "gcp-azure-tunnel"
  region        = var.region
  vpn_gateway   = google_compute_vpn_gateway.vpn_gateway.id
  peer_ip       = var.azure_ip
  shared_secret = var.psk
  router        = google_compute_router.router.id

  local_traffic_selector  = [var.subnet_cidr]
  remote_traffic_selector = [var.azure_cidr]
}

resource "google_compute_route" "route_aws" {
  name                = "route-to-aws"
  network             = google_compute_network.vpc.id
  dest_range          = var.aws_cidr
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel_aws.id
}

resource "google_compute_route" "route_azure" {
  name                = "route-to-azure"
  network             = google_compute_network.vpc.id
  dest_range          = var.azure_cidr
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.tunnel_azure.id
}
