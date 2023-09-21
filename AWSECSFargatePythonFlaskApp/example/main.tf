# Module declaration from projects

module "ecs_monitoring_app" {
  source                        = "git::https://github.com/nagajyothi0207/terraform_modules_registry//AWSECSFargatePythonFlaskApp?ref=v0.0.1"
  application_name              = var.application_name
  vpc_id                        = var.vpc_id
  subnets                       = var.subnets
  alb_inbound_allowed_public_ip = var.alb_inbound_allowed_public_ip
}