# Infrastructure

Terraform-managed AWS infrastructure for the CUSP Urban Observatory static site.

## Architecture

```
                    ┌─────────────┐
                    │   Route53   │
                    │  DNS Zones  │
                    └──────┬──────┘
                           │ A/AAAA/CNAME
                           ▼
┌──────────┐       ┌──────────────┐       ┌────────────┐
│   ACM    │──TLS──│  CloudFront  │──OAC──│  S3 Bucket │
│  Cert    │       │ Distribution │       │ (private)  │
└──────────┘       └──────────────┘       └────────────┘
                     │           │
              URL rewrite    Security headers
             (index.html)    (HSTS, CSP, etc.)
```

- **S3** — Private bucket (`cuspuo-site`), accessible only via CloudFront OAC
- **CloudFront** — CDN with TLS 1.2+, HTTP→HTTPS redirect, security headers, custom 404 page
- **CloudFront Function** — Rewrites directory paths (`/path/` → `/path/index.html`)
- **ACM** — TLS certificate with DNS validation for all active domains
- **Route53** — DNS zones for `cuspuo.org` and `cuspuo.com` with A, AAAA, CNAME, and CAA records
- **IAM** — GitHub Actions OIDC federation (no static credentials), separate deploy and terraform roles with permissions boundaries

## Active Domains

| Domain | DNS Provider | Status |
|--------|-------------|--------|
| cuspuo.org | Route53 | Active |
| www.cuspuo.org | Route53 | Active |
| cuspuo.com | Route53 | Active |
| www.cuspuo.com | Route53 | Active |
| muonetwork.com | GoDaddy | Deferred |
| muonetwork.org | GoDaddy | Deferred |

To enable the GoDaddy domains, set `external_domains = ["muonetwork.com", "muonetwork.org"]` in `variables.tf` and follow the output instructions for manual DNS configuration.

## CI/CD Workflows

| Workflow | Trigger | Action |
|----------|---------|--------|
| **Deploy Site** | Push to `master` (non-infra files) | S3 sync + CloudFront invalidation |
| **Terraform Plan** | PR with `infra/**` changes | Plan + Infracost cost estimate posted to PR |
| **Terraform Apply** | Push to `master` with `infra/**` changes | Auto-apply (no manual approval) |

## Prerequisites

- **AWS CLI** with profile `muon` configured for account `217832331713`
- **Terraform** >= 1.5.0

## Local Usage

All local terraform commands require the `muon` AWS profile:

```bash
cd infra

# Set profile for the session
export AWS_PROFILE=muon

# Standard workflow
terraform init
terraform plan
terraform apply
```

## State Management

- **State bucket:** `cuspuo-terraform-state` (S3, versioned, encrypted)
- **Lock table:** `cuspuo-terraform-lock` (DynamoDB)
- **State key:** `cuspuo-site/terraform.tfstate`

## Terraform Files

| File | Purpose |
|------|---------|
| `providers.tf` | AWS provider config and S3 backend |
| `variables.tf` | Input variables (domains, bucket names, GitHub config) |
| `locals.tf` | Computed values (domain lists, aliases) |
| `state.tf` | State bucket and DynamoDB lock table |
| `s3.tf` | Site bucket with OAC policy |
| `acm.tf` | TLS certificate and DNS validation |
| `cloudfront.tf` | CDN distribution, URL rewrite function, security headers |
| `iam.tf` | OIDC provider, deploy/terraform roles, permissions boundaries |
| `route53.tf` | DNS records (A, AAAA, CNAME, CAA) |
| `outputs.tf` | Distribution ID, role ARNs, GoDaddy instructions |

## IAM Roles

| Role | Purpose | Trust |
|------|---------|-------|
| `cuspuo-github-deploy` | S3 sync + CloudFront invalidation | `master` branch only |
| `cuspuo-github-terraform` | Infrastructure management | `master` branch, PRs, and `production-infra` environment |

Both roles use OIDC federation (no static AWS keys) and have permissions boundaries to prevent privilege escalation.

## Bootstrap from Scratch

If you ever need to recreate the infrastructure from zero:

1. Comment out the `backend "s3"` block in `providers.tf`
2. Run `terraform init` (uses local state)
3. Run `terraform apply -target=aws_s3_bucket.state -target=aws_s3_bucket_versioning.state -target=aws_s3_bucket_server_side_encryption_configuration.state -target=aws_s3_bucket_public_access_block.state -target=aws_dynamodb_table.state_lock`
4. Uncomment the backend block
5. Run `terraform init -migrate-state` to move state to S3
6. Run `terraform apply` for the full infrastructure
