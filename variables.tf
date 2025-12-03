variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

# IPs principales
variable "aws_ip" { type = string }
variable "azure_ip" { type = string }
variable "gcp_ip" { type = string }

# IPs adicionales para GCP (necesarias porque GCP usa HA VPN)
variable "aws_ip_for_gcp_1" { 
  type        = string
  description = "Primera IP del túnel AWS para GCP"
}

variable "aws_ip_for_gcp_2" { 
  type        = string
  description = "Segunda IP del túnel AWS para GCP"
}

variable "azure_ip_for_gcp" { 
  type        = string
  description = "IP de Azure para conexión GCP"
  default     = ""  # Si está vacío, usará var.azure_ip
}

variable "gcp_bgp_ip" {
  type        = string
  description = "Dirección BGP interna del túnel en GCP"
}

# Subnets
variable "aws_cidr" { type = string }
variable "azure_cidr" { type = string }
variable "gcp_cidr" { type = string }
variable "subnet_cidr" { type = string }

# PSKs - 3 diferentes (corregido)
variable "psk_aws" { 
  type        = string
  description = "PSK para conexión AWS ↔ Azure"
}

variable "psk_gcp" { 
  type        = string
  description = "PSK para conexión AWS ↔ GCP"
}

variable "psk_azure_gcp" { 
  type        = string
  description = "PSK para conexión Azure ↔ GCP"
}

# Credenciales Azure
variable "subscription_id" { type = string }
variable "tenant_id" { type = string }
variable "client_id" { type = string }
variable "client_secret" { type = string }