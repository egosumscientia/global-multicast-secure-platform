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

variable "aws_cidr" {
  type = string
}

variable "psk_aws" {
  type = string
}

variable "psk_gcp" {
  type = string
}
