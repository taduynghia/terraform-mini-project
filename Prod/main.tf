provider "aws" {
  region = var.aws_region
}
module "network" {
  source = "../modules/network"
  availability_zone = var.availability_zone

}

module "compute" {
  source     = "../modules/compute"
  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.subnet_ids
  instance_ami= var.instance_ami
  # lb_dns = module.compute.elb-enable_dns_hostname
}

