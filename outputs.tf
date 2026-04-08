###
# Einfuehrungsseite(n)

output "README" {
  value = templatefile("INTRO.md", { terra = module.terra.fqdn_vm })
}


