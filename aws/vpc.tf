resource "aws_vpc" "main" {
  cidr_block = var.aws_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "aws-multicloud-vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.aws_cidr, 8, 1)

  tags = {
    Name = "aws-multicloud-subnet"
  }
}
