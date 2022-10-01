terraform {
  required_version = "1.2.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
