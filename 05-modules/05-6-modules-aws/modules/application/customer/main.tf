resource "aws_instance" "customer" {
  ami                           = var.image
  instance_type                 = "t2.micro"
  associate_public_ip_address   = false
  user_data                     = var.user_data
  vpc_security_group_ids      = [var.vpc_security_group]
  subnet_id                   = var.subnet_id

  tags = {
    Name = "customer"
  }
}