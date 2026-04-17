## Übung 04-2 Wiederverwendung von Modulen

Erstellt eine `main.tf` und eine outputs.tf

    module "web" {
      source = "../../03-aws/03-3-web"
      
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }
    
    module "db" {
      source = "../../03-aws/03-4-db"
      
      name_prefix = var.name_prefix
      common_tags = var.common_tags
    }


output.tf

    output "website_bucket_name" {
      value = module.web.website_bucket_name
    }
    
    output "website_url" {
      value = module.web.website_url
    }
 
 
              