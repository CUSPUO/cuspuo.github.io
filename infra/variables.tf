variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "muon"
}

variable "site_bucket_name" {
  description = "S3 bucket name for the static site"
  type        = string
  default     = "cuspuo-site"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "cuspuo-terraform-state"
}

variable "state_lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "cuspuo-terraform-lock"
}

variable "github_org" {
  description = "GitHub organization name (lowercase, as used in OIDC sub claim)"
  type        = string
  default     = "cuspuo"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "cuspuo.github.io"
}

variable "github_branch" {
  description = "Branch allowed to assume the deploy IAM role"
  type        = string
  default     = "master"
}

variable "primary_domain" {
  description = "Primary domain name (used as ACM certificate CN)"
  type        = string
  default     = "cuspuo.org"
}

variable "route53_domains" {
  description = "Map of domains managed in Route53, with their hosted zone IDs"
  type = map(object({
    zone_id = string
  }))
  default = {
    "cuspuo.org" = { zone_id = "Z0367339LAAK1PCREG43" }
    "cuspuo.com" = { zone_id = "Z0778151188PUBAI3NXUI" }
  }
}

variable "external_domains" {
  description = "List of domains NOT in Route53 (e.g., GoDaddy). ACM validation will be output for manual creation."
  type        = list(string)
  default     = [] # Add ["muonetwork.com", "muonetwork.org"] when ready to configure GoDaddy domains
}
