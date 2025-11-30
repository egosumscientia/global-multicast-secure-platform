variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azure_ip" {
  type = string
}

variable "gcp_ip" {
  type = string
}

variable "azure_cidr" {
  type = string
}

variable "gcp_cidr" {
  type = string
}

variable "psk_azure" {
  type = string
}

variable "psk_gcp" {
  type = string
}
