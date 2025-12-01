variable "project" { type = string }
variable "region" { type = string }
variable "zone" { type = string }

variable "aws_ip" { type = string }
variable "azure_ip" { type = string }
variable "gcp_ip" { type = string }

variable "aws_cidr" { type = string }
variable "azure_cidr" { type = string }
variable "gcp_cidr" { type = string }

variable "subnet_cidr" { type = string }

# PSKs reales
variable "psk_aws" { type = string } # AWS ↔ Azure
variable "psk_gcp" { type = string } # Azure ↔ GCP

variable "subscription_id" { type = string }
variable "tenant_id" { type = string }
variable "client_id" { type = string }
variable "client_secret" { type = string }
