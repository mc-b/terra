
# Network

module "network" {
  source = "../05-6-modules-aws/modules/network"
}

# Security

module "security" {
  source = "../05-6-modules-aws/modules/security"
  vpc_id = module.network.vpc.id
}

# Reverse Proxy

module "routing" {
  source             = "../05-6-modules-aws/modules/routing"
  vpc_security_group = module.security.external_security_group_id
  subnet_id          = module.network.intern_subnet_id
  vpc                = module.network.vpc
  image              = var.image
  user_data          = data.template_file.webshop.rendered
}

# Applications

module "application_order" {
  source             = "../05-6-modules-aws/modules/application/order"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.order.rendered
}

module "application_customer" {
  source             = "../05-6-modules-aws/modules/application/customer"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.customer.rendered
}

module "application_catalog" {
  source             = "../05-6-modules-aws/modules/application/catalog"
  vpc_security_group = module.security.intern_security_group_id
  subnet_id          = module.network.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.catalog.rendered
}


