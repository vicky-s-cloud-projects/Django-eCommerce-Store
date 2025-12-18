module "vpc" {
  source = "./vpc"
}

module "eks" {
  source          = "./eks"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "rds" {
  source            = "./rds"
  vpc_id            = module.vpc.vpc_id
  database_subnets  = module.vpc.database_subnets
  eks_node_sg_id    = module.eks.node_security_group_id
}

module "waf" {
  source = "./waf"

  providers = {
    aws = aws.us_east_1
  }

  project_name = var.project_name
}

module "cloudfront" {
  source = "./cloudfront"

  providers = {
    aws = aws.us_east_1
  }

  project_name           = var.project_name
  internal_alb_dns_name  = var.internal_alb_dns_name
  waf_web_acl_arn        = module.waf.web_acl_arn
}
