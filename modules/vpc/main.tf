
module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=tags/v2.60.0"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.vpc_azs
  public_subnets  = var.vpc_public_subnet

}