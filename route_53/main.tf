resource "aws_route53_record" "apache-record" {
  zone_id = data.aws_route53_zone.apache-domain.zone_id
  name    = "www.${var.domain_name}"
  type    = var.record_type
  alias {
    name                    = var.aws_lb_name
    zone_id                 = var.aws_zone_id
    evaluate_target_health  = var.evaluate_target_health
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
    for dvo in var.validation_option : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = var.route_53_overwrite_option
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.time_to_live
  type            = each.value.type
  zone_id         = data.aws_route53_zone.apache-domain.id
}