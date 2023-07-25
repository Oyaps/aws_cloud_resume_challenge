
#### SSL Certificate ####

resource "aws_acm_certificate" "ssl_primary_cert" {
    
    domain_name       = var.primary_domain_name
        subject_alternative_names = [
        "*.${var.primary_domain_name}",
        "www.${var.primary_domain_name}"
    ]

    validation_method = "DNS"

    tags = {
        Name = "${var.tag_name_pfx}-certificate"

    }

    lifecycle {
        create_before_destroy = true
        ignore_changes = [tags]
    }
}

resource "aws_route53_record" "cert_primary_verify" {
    for_each = {
        for dvo in aws_acm_certificate.ssl_primary_cert.domain_validation_options : dvo.domain_name => {
        name   = dvo.resource_record_name
        record = dvo.resource_record_value
        type   = dvo.resource_record_type
        }
        
    }
    
    allow_overwrite = true
    name            = each.value.name
    records         = [each.value.record]
    ttl             = 60
    type            = each.value.type
    zone_id         = var.primary_zone_id
}


resource "aws_acm_certificate_validation" "ssl_cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl_primary_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_primary_verify : record.fqdn]
}


