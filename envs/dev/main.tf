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
}

module "ec2" {
  source = "../../modules/ec2"

  project            = "nadia-dev"
  ami_id             = "ami-0c1c30571d2dae5c5"   # Amazon Linux 2 (eu-west-2)
  instance_type      = "t2.micro"
  subnet_id          = module.vpc.public_subnets[0]
  security_group_id  = module.security_groups.public_ec2_sg_id

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Nadia's EC2 instance" > /var/www/html/index.html
  EOF
}

module "alb" {
  source = "../../modules/alb"

  project            = "nadia-dev"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  security_group_id  = module.security_groups.alb_sg_id

  instance_id        = module.ec2.instance_id
  target_port        = 80
}

