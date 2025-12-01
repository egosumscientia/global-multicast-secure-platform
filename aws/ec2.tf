resource "aws_key_pair" "multicloud" {
  key_name   = "multicloud"
  public_key = file("~/.ssh/multicloud.pub")
}

resource "aws_security_group" "vm_sg" {
  name        = "multicloud-vm-sg"
  description = "Allow SSH and ICMP for multinube"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["186.114.59.232/32"]
  }

  ingress {
    description = "ICMP ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vm" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.multicloud.key_name
  vpc_security_group_ids      = [aws_security_group.vm_sg.id]

  tags = {
    Name = "aws-multicloud-vm"
  }
}
