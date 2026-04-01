provider "aws" {
  region = "us-east-1"
}

module "secure_vpc" {
  source = "../../"

  name_prefix = "portfolio-secure"

  vpc_cidr             = "10.50.0.0/16"
  public_subnet_cidrs  = ["10.50.1.0/24", "10.50.2.0/24"]
  private_subnet_cidrs = ["10.50.11.0/24", "10.50.12.0/24"]

  alb_ingress_cidrs        = ["0.0.0.0/0"]
  alb_deletion_protection  = true
  flow_logs_retention_days = 90

  tags = {
    Environment = "demo"
    Owner       = "platform-team"
    ManagedBy   = "terraform"
  }
}

output "vpc_id" {
  value = module.secure_vpc.vpc_id
}

output "alb_dns_name" {
  value = module.secure_vpc.alb_dns_name
}
