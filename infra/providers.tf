terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 backend will be configured after bootstrap (state.tf resources created first)
  # Uncomment after running: terraform apply -target=aws_s3_bucket.state -target=aws_dynamodb_table.state_lock
  # Then run: terraform init -migrate-state
  #
  # backend "s3" {
  #   bucket         = "cuspuo-terraform-state"
  #   key            = "cuspuo-site/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "cuspuo-terraform-lock"
  #   encrypt        = true
  #   profile        = "muon"
  # }
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
