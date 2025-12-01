########################################
# VPC PRINCIPAL (SIN CAMBIOS)
########################################
resource "aws_vpc" "main" {
  cidr_block           = var.aws_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-multicloud-vpc"
  }
}

########################################
# Internet Gateway (IGW)
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-multicloud-igw"
  }
}


########################################
# SUBNET EXISTENTE (PÚBLICA) — SIN CAMBIOS
########################################
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.aws_cidr, 8, 1)

  tags = {
    Name = "aws-multicloud-subnet"
  }
}

########################################
# NUEVA SUBNET PRIVADA (ESTO ES NUEVO)
########################################
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.aws_cidr, 8, 2)
  map_public_ip_on_launch = false

  tags = {
    Name = "aws-multicloud-private-subnet"
  }
}