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
  
  region  = var.region
  
  # IPs públicas
  aws_ip = var.aws_ip
  gcp_ip = "34.157.226.19" # IP de la Interfaz 1 del Gateway GCP (donde está el túnel)
  azure_ip = var.azure_ip
  
  aws_cidr   = var.aws_cidr
  azure_cidr = var.azure_cidr
  gcp_cidr   = var.gcp_cidr
  
  # PSKs CORREGIDOS:
  psk_aws       = var.psk_aws        # Para Azure↔AWS
  psk_azure_gcp = var.psk_azure_gcp  # Para Azure↔GCP ← NUEVO
  
  gcp_bgp_ip = var.gcp_bgp_ip
  
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
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

  # IPs dinámicas de túneles AWS
  aws_tunnel1_ip = module.aws.vpn_aws_gcp_tunnel1_ip
  aws_tunnel2_ip = module.aws.vpn_aws_gcp_tunnel2_ip

  # CIDRs remotos
  aws_cidr   = var.aws_cidr
  azure_cidr = var.azure_cidr
  gcp_cidr   = var.gcp_cidr

  # PSKs correctos separados por conexión
  psk_gcp_aws   = var.psk_gcp       # GCP ↔ AWS
  psk_gcp_azure = var.psk_azure_gcp # GCP ↔ Azure
}
