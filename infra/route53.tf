resource "aws_route53_record" "apex_a" {
  for_each = var.route53_domains

  zone_id = each.value.zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true
}

resource "aws_route53_record" "apex_aaaa" {
  for_each = var.route53_domains

  zone_id = each.value.zone_id
  name    = each.key
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }

  allow_overwrite = true
}

resource "aws_route53_record" "www" {
  for_each = var.route53_domains

  zone_id = each.value.zone_id
  name    = "www.${each.key}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_cloudfront_distribution.site.domain_name]

  allow_overwrite = true
}

resource "aws_route53_record" "caa" {
  for_each = var.route53_domains

  zone_id = each.value.zone_id
  name    = each.key
  type    = "CAA"
  ttl     = 3600

  records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}
