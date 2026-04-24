###
# Einfuehrungsseite(n)

output "README" {
  value = templatefile("INTRO.md", { control = module.control.fqdn_vm })
}


