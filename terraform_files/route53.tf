resource "aws_route53_record" "apache-record" {
  zone_id = data.aws_route53_zone.apache-domain.zone_id
  name    = "www.sammybisnuel.net"
  type    = "A"
  alias {
    name = aws_lb.apache-lb.dns_name
    zone_id = aws_lb.apache-lb.zone_id
    evaluate_target_health = true
  }
}