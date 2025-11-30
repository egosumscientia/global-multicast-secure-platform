module "aws" {
  source = "./aws"

  region      = var.region
  azure_ip    = var.azure_ip
  gcp_ip      = var.gcp_ip

  azure_cidr  = var.azure_cidr
  gcp_cidr    = var.gcp_cidr
  aws_cidr    = var.aws_cidr

  psk_azure   = var.psk_azure
  psk_gcp     = var.psk_gcp
}


module "azure" {
  source = "./azure"

  region       = var.region
  aws_ip       = var.aws_ip
  gcp_ip       = var.gcp_ip
  aws_cidr     = var.aws_cidr
  gcp_cidr     = var.gcp_cidr
  azure_cidr   = var.azure_cidr
  psk_aws      = var.psk_azure
  psk_gcp      = var.psk_gcp

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}


module "gcp" {
  source = "./gcp"

  project      = var.project
  region       = var.region
  zone         = var.zone

  subnet_cidr  = var.subnet_cidr

  aws_ip       = var.aws_ip
  azure_ip     = var.azure_ip

  aws_cidr     = var.aws_cidr
  azure_cidr   = var.azure_cidr
  gcp_cidr     = var.gcp_cidr

  psk          = var.psk
}
