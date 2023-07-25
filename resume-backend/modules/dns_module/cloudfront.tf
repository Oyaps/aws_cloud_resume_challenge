

# Cloudfront distribution for main s3 site of the subdomain.
resource "aws_cloudfront_distribution" "domain_s3_distribution" {
  origin {
    domain_name = var.domain_name
    origin_id   = "S3-.${var.bucket_name}"
    /* origin_access_control_id = aws_cloudfront_origin_access_control.default.id */

  }

  origin {
    domain_name = "www.${var.domain_name}"
    origin_id   = "S3-www.${var.bucket_name}"
    /* origin_access_control_id = aws_cloudfront_origin_access_control.default.id */

  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.primary_domain_name, "www.${var.primary_domain_name}"]


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-www.${var.bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.ssl_cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = {
        Name = "${var.tag_name_pfx}-Cloudfront"

    }
}

# Cloudfront S3 for redirect to root domain.
/* resource "aws_cloudfront_distribution" "root_domain_s3_distribution" {
  origin {
    domain_name = var.domain_name
    origin_id   = "S3-.${var.bucket_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-.${var.bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.ssl_cert_validation.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  tags = var.tag_name_pfx
} */