resource "aws_route53_record" "apache-record" {
  zone_id = data.aws_route53_zone.apache-domain.zone_id
  name    = "*.${var.domain_name}"
  type    = "A"
  alias {
    name = aws_lb.apache-lb.dns_name
    zone_id = aws_lb.apache-lb.zone_id
    evaluate_target_health = true
  }
}

######################################
#Code for DNS validation
######################################

data "aws_route53_zone" "apache-domain" { 
  name         = var.domain_name
  private_zone = var.private_zone
}

resource "aws_route53_record" "apache-domain" {
  for_each = {
    for dvo in module.acm.validation_option : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = var.overwrite_option
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.time_to_live
  type            = each.value.type
  zone_id         = data.aws_route53_zone.apache-domain.id
}