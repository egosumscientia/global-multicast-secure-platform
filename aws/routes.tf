############################################
# ROUTE TABLE PÚBLICA (para IGW)
############################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "aws-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

############################################
# ROUTE TABLE PRIVADA (para VPN)
############################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "aws-private-rt"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

############################################
# RUTA A AZURE DESDE AWS (por VGW)
############################################
resource "aws_route" "to_azure" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.azure_cidr
  gateway_id             = aws_vpn_gateway.vgw.id
}

############################################
# RUTA A GCP DESDE AWS (por VGW)
############################################
resource "aws_route" "to_gcp" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.gcp_cidr
  gateway_id             = aws_vpn_gateway.vgw.id
}
