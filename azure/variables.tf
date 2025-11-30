variable "region" {
  type = string
}

variable "aws_ip" {
  type = string
}

variable "gcp_ip" {
  type = string
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

variable "psk_aws" {
  type = string
}

variable "psk_gcp" {
  type = string
}

variable "subscription_id" { type = string }
variable "tenant_id"       { type = string }
variable "client_id"       { type = string }
variable "client_secret"   { type = string }
