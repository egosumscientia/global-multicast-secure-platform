##############################
#  MÓDULO AWS
##############################
module "aws" {
  source = "./aws"

  region = var.region

  # IPs públicas de los gateways remotos
  azure_ip = var.azure_ip
  gcp_ip   = var.gcp_ip

  # CIDRs remotos
  azure_cidr = var.azure_cidr
  gcp_cidr   = var.gcp_cidr
  aws_cidr   = var.aws_cidr

  # PSKs correctos
  psk_aws = var.psk_aws # AWS ↔ AZURE
  psk_gcp = var.psk_gcp # AWS ↔ GCP
}


##############################
#  MÓDULO AZURE
##############################
module "azure" {
  source = "./azure"

  region = var.region

  # IPs públicas remotas
  aws_ip = var.aws_ip
  gcp_ip = var.gcp_ip

  # CIDRs remotos
  aws_cidr   = var.aws_cidr
  gcp_cidr   = var.gcp_cidr
  azure_cidr = var.azure_cidr

  # PSKs
  psk_aws = var.psk_aws
  psk_gcp = var.psk_gcp

  # Credenciales Azure
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # BGP
  gcp_bgp_ip = var.gcp_bgp_ip
}


##############################
#  MÓDULO GCP
##############################
module "gcp" {
  source = "./gcp"

  project = var.project
  region  = var.region
  zone    = var.zone

  subnet_cidr = var.subnet_cidr

  # IPs públicas remotas
  aws_ip   = var.aws_ip
  azure_ip = var.azure_ip

  # CIDRs remotos
  aws_cidr   = var.aws_cidr
  azure_cidr = var.azure_cidr
  gcp_cidr   = var.gcp_cidr

  # PSK correcto
  psk = var.psk_gcp # AZURE ↔ GCP
}
