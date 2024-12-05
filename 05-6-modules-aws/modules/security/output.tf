

output "intern_security_group_id" {
  value = aws_security_group.webshop_intern.id
}

output "external_security_group_id" {
  value = aws_security_group.webshop.id
}