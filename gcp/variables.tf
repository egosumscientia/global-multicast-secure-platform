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

variable "psk" {
  type = string
}

variable "aws_cidr" {
  type = string
}

variable "azure_cidr" {
  type = string
}
