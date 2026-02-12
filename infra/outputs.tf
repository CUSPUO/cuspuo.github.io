output "cloudfront_distribution_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.site.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.site.id
}

output "s3_bucket_name" {
  description = "S3 site bucket name"
  value       = aws_s3_bucket.site.id
}

output "deploy_role_arn" {
  description = "IAM role ARN for GitHub Actions content deployment"
  value       = aws_iam_role.github_deploy.arn
}

output "terraform_role_arn" {
  description = "IAM role ARN for GitHub Actions Terraform management"
  value       = aws_iam_role.github_terraform.arn
}

output "godaddy_acm_validation_records" {
  description = "ACM DNS validation CNAME records to add manually in GoDaddy"
  value = {
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.domain_name => {
      cname_name  = dvo.resource_record_name
      cname_value = dvo.resource_record_value
    }
    if !contains(keys(local.domain_to_zone), dvo.domain_name)
  }
}

output "godaddy_dns_instructions" {
  description = "Instructions for GoDaddy DNS setup"
  value       = <<-EOT

    ====================================================================
    GoDaddy DNS Setup Instructions
    ====================================================================

    After ACM certificate validation, add these records in GoDaddy
    for muonetwork.com and muonetwork.org:

    1. www CNAME record:
       Name:  www
       Type:  CNAME
       Value: ${aws_cloudfront_distribution.site.domain_name}

    2. Apex domain forwarding:
       Forward muonetwork.com -> https://www.muonetwork.com (301)
       Forward muonetwork.org -> https://www.muonetwork.org (301)

    3. CAA records (recommended):
       Name:  @
       Type:  CAA
       Value: 0 issue "amazon.com"
       Value: 0 issuewild "amazon.com"

    ====================================================================
  EOT
}
