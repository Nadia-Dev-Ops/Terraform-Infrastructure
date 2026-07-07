module "vpc" {
  source = "../../modules/vpc"

  project              = "nadia-dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  azs                  = ["eu-west-2a", "eu-west-2b"]
}

module "security_groups" {
  source = "../../modules/security-groups"

  project = "nadia-dev"
  vpc_id  = module.vpc.vpc_id
  rds_port = 5432
}
