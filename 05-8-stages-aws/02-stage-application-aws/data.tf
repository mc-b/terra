# Import State von 01-stage-infrastructure

data "terraform_remote_state" "infrastructure" {
  backend = "local"

  config = {
    path = "../01-stage-infrastructure/terraform.tfstate"
  }
}