terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "cuspuo-terraform-state"
    key            = "cuspuo-site/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "cuspuo-terraform-lock"
    encrypt        = true
    profile        = "muon"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      Project   = "cuspuo-site"
      ManagedBy = "terraform"
    }
  }
}
