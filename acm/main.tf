resource "aws_acm_certificate" "cert" {
  domain_name       = "*.${var.domain_name}" 
  validation_method = var.validation_method 
  key_algorithm     = var.key_algorithm

  tags = {
    Name = var.domain_tag_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "apache-domain" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.route53_record
}

