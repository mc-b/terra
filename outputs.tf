###
# Einfuehrungsseite(n)

output "README" {
  value = templatefile("INTRO.md", { git = module.git.fqdn_vm })
}


