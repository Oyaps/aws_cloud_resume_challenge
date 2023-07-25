
# Route 53 for domain
/* resource "aws_route53_zone" "root_domain" {
  name = var.primary_domain_name
  tags = {
        Name = "${var.tag_name_pfx}-route53"

    }
} */

##### A record for the root domain ##### 
resource "aws_route53_record" "domain_root" {
  zone_id = var.primary_zone_id
  name    = var.primary_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.domain_s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.domain_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

##### A record for the subdomain #####
resource "aws_route53_record" "subdomain" {
  zone_id = var.primary_zone_id
  name    = "www.${var.primary_domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.domain_s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.domain_s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}



