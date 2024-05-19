resource "aws_acm_certificate" "cert" {
  domain_name       = "*.sammybisnuel.net"
  validation_method = "DNS"
  key_algorithm = "RSA_2048"

  tags = {
    Name = "bisnuel-public-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

######################################
#Code for DNS validation
######################################

data "aws_route53_zone" "apache-domain" { 
  name         = "sammybisnuel.net"
  private_zone = false
}

resource "aws_route53_record" "apache-domain" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.apache-domain.id
}

resource "aws_acm_certificate_validation" "apache-domain" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.apache-domain : record.fqdn]
}

