
# Applications

module "application_order" {
  source             = "../../05-6-modules-aws/modules/application/order"
  vpc_security_group = data.terraform_remote_state.infrastructure.outputs.intern_security_group_id
  subnet_id          = data.terraform_remote_state.infrastructure.outputs.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.order.rendered
}

module "application_customer" {
  source             = "../../05-6-modules-aws/modules/application/customer"
  vpc_security_group = data.terraform_remote_state.infrastructure.outputs.intern_security_group_id
  subnet_id          = data.terraform_remote_state.infrastructure.outputs.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.customer.rendered
}

module "application_catalog" {
  source             = "../../05-6-modules-aws/modules/application/catalog"
  vpc_security_group = data.terraform_remote_state.infrastructure.outputs.intern_security_group_id
  subnet_id          = data.terraform_remote_state.infrastructure.outputs.intern_subnet_id
  image              = var.image
  user_data          = data.template_file.catalog.rendered
}


