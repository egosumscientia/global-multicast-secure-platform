variable "region" {
  type = string
}

variable "aws_ip" {
  type = string
}

variable "gcp_ip" {
  type = string
}

variable "azure_ip" {
  type = string
  description = "IP pública de Azure VPN Gateway"
}

variable "aws_cidr" {
  type = string
}

variable "gcp_cidr" {
  type = string
}

variable "azure_cidr" {
  type = string
}

# PSKs - CORREGIDO: necesitamos 2 diferentes
variable "psk_aws" {
  type        = string
  description = "PSK para conexión Azure ↔ AWS"
}

variable "psk_azure_gcp" {  # ← CAMBIAR NOMBRE
  type        = string
  description = "PSK para conexión Azure ↔ GCP"
}

variable "gcp_bgp_ip" {
  type        = string
  description = "Dirección BGP interna del túnel en GCP (ej: 169.254.x.x)"
}

# Credenciales Azure (dejar igual)
variable "subscription_id" { 
  type = string 
}

variable "tenant_id" { 
  type = string 
}

variable "client_id" { 
  type = string 
}

variable "client_secret" { 
  type = string 
}