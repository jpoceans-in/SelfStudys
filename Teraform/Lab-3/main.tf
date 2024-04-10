locals {
  env    = terraform.workspace
  prefix = {
    "prod" = "${var.pProject}-${local.env}"
    "dev"  = "${var.pProject}-${local.env}"
  }
  prefixEnv = lookup(local.prefix, local.env)

}
module "vpc" {
  source    = "./modules/vpc"
  prefixEnv = local.prefixEnv
}
