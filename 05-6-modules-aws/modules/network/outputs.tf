

output "vpc" {
  value = aws_vpc.webshop
}

output "intern_subnet_id" {
  value = aws_subnet.webshop_intern.id
}

