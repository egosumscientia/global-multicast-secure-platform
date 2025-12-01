output "aws_public_ip" {
  value = aws_instance.vm.public_ip
}

output "aws_private_ip" {
  value = aws_instance.vm.private_ip
}

output "aws_vgw_id" {
  value = aws_vpn_gateway.vgw.id
}
