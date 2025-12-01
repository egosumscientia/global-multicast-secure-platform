########################################
# NETWORK / SUBNET / VM
########################################

output "gcp_network_id" {
  value = google_compute_network.vpc.id
}

output "gcp_subnet_id" {
  value = google_compute_subnetwork.subnet.id
}

output "gcp_vm_name" {
  value = google_compute_instance.vm.name
}

output "gcp_vm_private_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "gcp_vm_public_ip" {
  value = google_compute_address.public_ip.address
}


########################################
# AWS VPN TUNNELS (2)
########################################

output "gcp_aws_tunnel_1_id" {
  value = google_compute_vpn_tunnel.aws_tunnel_1.id
}

output "gcp_aws_tunnel_2_id" {
  value = google_compute_vpn_tunnel.aws_tunnel_2.id
}

########################################
# AZURE VPN TUNNEL (1)
########################################

output "gcp_azure_tunnel_id" {
  value = google_compute_vpn_tunnel.azure_tunnel.id
}


########################################
# AWS BGP PEERS
########################################

output "gcp_bgp_peer_aws_1" {
  value = google_compute_router_peer.aws_bgp_peer_1.name
}

output "gcp_bgp_peer_aws_2" {
  value = google_compute_router_peer.aws_bgp_peer_2.name
}
