variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "subnet_cidr" {
  type = string
}

variable "aws_ip" {
  type = string
}

variable "azure_ip" {
  type = string
}

# Variables for AWS VPN tunnel IPs (dynamic)
variable "aws_tunnel1_ip" {
  type        = string
  description = "Public IP of AWS VPN tunnel 1"
}

variable "aws_tunnel2_ip" {
  type        = string
  description = "Public IP of AWS VPN tunnel 2"
}

# Separate PSKs for different connections
variable "psk_gcp_aws" {
  type        = string
  description = "PSK for GCP ↔ AWS connection"
}

variable "psk_gcp_azure" {
  type        = string
  description = "PSK for GCP ↔ Azure connection"
}

variable "aws_cidr" {
  type = string
}

variable "azure_cidr" {
  type = string
}

variable "gcp_cidr" {
  type = string
}
