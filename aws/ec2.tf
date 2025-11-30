resource "aws_instance" "vm" {
  ami                         = "ami-0c02fb55956c7d316" # Amazon Linux 2 us-east-1
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.multicloud.key_name

  tags = {
    Name = "aws-multicloud-vm"
  }
}

resource "aws_key_pair" "multicloud" {
  key_name   = "multicloud"
  public_key = file("~/.ssh/multicloud.pub")
}
