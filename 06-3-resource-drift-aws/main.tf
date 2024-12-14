
# Security Group 

resource "aws_security_group" "webshop" {
  name        = "webshop"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VM

resource "aws_instance" "webshop" {
  ami                           = var.image
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  user_data                     = data.template_file.webshop.rendered
  vpc_security_group_ids        = [aws_security_group.webshop.id]

  tags = {
    Name = "Webshop"
  }
}


