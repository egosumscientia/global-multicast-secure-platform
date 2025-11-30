output "azure_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "azure_private_ip" {
  value = azurerm_network_interface.nic.ip_configuration[0].private_ip_address
}

output "azure_vpn_public_ip" {
  value = azurerm_public_ip.vpn_ip.ip_address
}
