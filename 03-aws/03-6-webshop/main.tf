terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}


provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# VPC inkl. Zugriff via Internet. Braucht alle vier Eintraege damit es funktioniert

resource "aws_vpc" "webshop" {
  cidr_block = "10.0.0.0/16"
  # DNS Namen muessen aktiviert und im Cloud-init Script der hostname gesetzt werden.
  enable_dns_support   = true
  enable_dns_hostnames = true
}
resource "aws_internet_gateway" "webshop" {
  vpc_id = aws_vpc.webshop.id
}
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.webshop.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.webshop.id
}

resource "aws_route_table_association" "webshop_public" {
  subnet_id      = aws_subnet.webshop_intern.id
  route_table_id = aws_vpc.webshop.main_route_table_id
}


# Subnet fuer interne Server. So kann webshop auf order, customer, catalog zugreifen, aber nicht das Internet

resource "aws_subnet" "webshop_intern" {
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.webshop.id
}

# Interne Security Group

resource "aws_security_group" "webshop_intern" {
  name   = "webshop_intern"
  vpc_id = aws_vpc.webshop.id

  # SSH access vom Subnetz
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # HTTP access vom Subnetz
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Externe Security Group 

resource "aws_security_group" "webshop" {
  name   = "webshop"
  vpc_id = aws_vpc.webshop.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access vom Subnetz
  ingress {
    from_port   = 80
    to_port     = 80
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

# VMs

resource "aws_instance" "order" {
  ami                         = var.image
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  user_data                   = templatefile(data.local_file.order.filename, {})
  vpc_security_group_ids      = [aws_security_group.webshop_intern.id]
  subnet_id                   = aws_subnet.webshop_intern.id

  tags = {
    Name = "order"
  }
}

resource "aws_instance" "customer" {
  ami                         = var.image
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  user_data                   = templatefile(data.local_file.customer.filename, {})
  vpc_security_group_ids      = [aws_security_group.webshop_intern.id]
  subnet_id                   = aws_subnet.webshop_intern.id

  tags = {
    Name = "customer"
  }
}

resource "aws_instance" "catalog" {
  ami                         = var.image
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  user_data                   = templatefile(data.local_file.catalog.filename, {})
  vpc_security_group_ids      = [aws_security_group.webshop_intern.id]
  subnet_id                   = aws_subnet.webshop_intern.id

  tags = {
    Name = "catalog"
  }
}

resource "aws_instance" "webshop" {
  ami                         = var.image
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = templatefile(data.local_file.webshop.filename, {})
  vpc_security_group_ids      = [aws_security_group.webshop.id]
  subnet_id                   = aws_subnet.webshop_intern.id

  tags = {
    Name = "Webshop"
  }
}

