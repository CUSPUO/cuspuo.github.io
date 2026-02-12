locals {
  all_domains = concat(keys(var.route53_domains), var.external_domains)

  all_sans = flatten([
    for domain in local.all_domains : [domain, "www.${domain}"]
  ])

  primary_domain = var.primary_domain

  cloudfront_aliases = local.all_sans

  s3_origin_id = "S3-${var.site_bucket_name}"

  # Map every Route53 domain and its www variant to the zone_id
  domain_to_zone = merge([
    for domain, config in var.route53_domains : {
      (domain)        = config.zone_id
      "www.${domain}" = config.zone_id
    }
  ]...)
}
