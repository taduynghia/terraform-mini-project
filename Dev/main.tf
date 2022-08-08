provider "aws" {
  region = var.aws_region
}

module "network" {
  source                         = "../modules/network"
  availability_zone              = var.availability_zone
  public_subnet_cidr_blocks      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidr_blocks_ec2 = ["10.0.11.0/24", "10.0.12.0/24"]
  private_subnet_cidr_blocks_rds = ["10.0.13.0/24", "10.0.14.0/24"]
}

module "database" {
  source            = "../modules/database"
  availability_zone = var.availability_zone
  depends_on        = [module.network]
}

module "compute" {
  source         = "../modules/compute"
  instance_ami   = var.instance_ami
  aws_region     = var.aws_region
  
  aws_key_id     = "AKIA5I6644IMEWFJTGUY"
  aws_access_key = "1z9Wy0Su24H2vtGKrlKaemXizctnC9+WZGdxrh4j"
  depends_on = [module.network, module.database]
}
