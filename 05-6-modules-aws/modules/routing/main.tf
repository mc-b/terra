

resource "aws_internet_gateway" "webshop" {
  vpc_id = var.vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = var.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.webshop.id
}

resource "aws_instance" "webshop" {
  ami                         = var.image
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = var.user_data
  vpc_security_group_ids      = [var.vpc_security_group]
  subnet_id                   = var.subnet_id

  tags = {
    Name = "Webshop"
  }
}
