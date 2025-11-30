module "aws" {
  source = "./aws"

  azure_ip   = var.azure_ip
  gcp_ip     = var.gcp_ip

  azure_cidr = var.azure_cidr
  gcp_cidr   = var.gcp_cidr

  psk_azure  = var.psk
  psk_gcp    = var.psk
}

module "azure" {
  source = "./azure"

  aws_ip    = var.aws_ip
  gcp_ip    = var.gcp_ip

  aws_cidr  = var.aws_cidr
  gcp_cidr  = var.gcp_cidr

  psk_aws   = var.psk
  psk_gcp   = var.psk
}

module "gcp" {
  source = "./gcp"

  project     = var.project
  region      = var.region
  zone        = var.zone
  subnet_cidr = var.gcp_cidr    # usamos el CIDR GCP como subnet también

  aws_ip     = var.aws_ip
  azure_ip   = var.azure_ip

  aws_cidr   = var.aws_cidr
  azure_cidr = var.azure_cidr

  psk        = var.psk
}
