output "gcp_public_ip" {
  value = google_compute_address.public_ip.address
}

output "gcp_private_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "gcp_vpn_public_ip" {
  value = google_compute_vpn_gateway.vpn_gateway.self_link
}
