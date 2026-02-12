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
    # No profile here — uses AWS_PROFILE env var locally, OIDC env vars in CI
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.aws_profile != "" ? var.aws_profile : null

  default_tags {
    tags = {
      Project   = "cuspuo-site"
      ManagedBy = "terraform"
    }
  }
}
