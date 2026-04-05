###
#   Outputs wie IP-Adresse und DNS Name
#

output "ip_vm" {
  value = module.myvm.*.ip_vm
  description = "The IP address of the server instance."
}

output "fqdn_vm" {
  value = module.myvm.*.fqdn_vm
  description = "The FQDN of the server instance."
}
  
output "description" {
  value       = module.myvm.*.description
  description = "Description VM"
}  

   
# Einfuehrungsseiten

output "README" {
  value = templatefile( "INTRO.md", { ip = join(" ", module.myvm.*.ip_vm), fqdn = join(" ", module.myvm.*.fqdn_vm), ADDR = join(" ", module.myvm.*.ip_vm) } )
}
