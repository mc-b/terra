
# Network

module "network" {
  source = "./modules/network"
}

# Security

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc.id
}

# Reverse Proxy

module "routing" {
  source             = "./modules/routing"
  vpc_security_group = module.security.external_security_group_id
  subnet_id          = module.network.intern_subnet_id
  vpc                = module.network.vpc
  image              = var.image
  user_data          = data.template_file.webshop.rendered
}

# Applications

module "application_order" {
  source             = "./modules/application/order"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.order.rendered
}

module "application_customer" {
  source             = "./modules/application/customer"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.customer.rendered
}

module "application_catalog" {
  source             = "./modules/application/catalog"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.catalog.rendered
}


