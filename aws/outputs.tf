output "aws_public_ip" {
  value = aws_instance.vm.public_ip
}

output "aws_private_ip" {
  value = aws_instance.vm.private_ip
}

output "aws_vgw_id" {
  value = aws_vpn_gateway.vgw.id
}

output "vpn_aws_gcp_tunnel1_ip" {
  description = "Public IP of AWS VPN tunnel 1 to GCP"
  value       = aws_vpn_connection.vpn_aws_gcp.tunnel1_address
}

output "vpn_aws_gcp_tunnel2_ip" {
  description = "Public IP of AWS VPN tunnel 2 to GCP"
  value       = aws_vpn_connection.vpn_aws_gcp.tunnel2_address
}
