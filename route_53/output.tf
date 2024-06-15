# output "domain_name" {
#     value = var.domain_name
# }

# output "route53_record" {
#   value = [
#     for record in aws_route53_record.apache-record : record.fqdn
#   ]
# }

output "route53_record_name" {
  description = "The name of the record"
  value       = var.domain_name
}

output "route53_record_fqdn" {
  description = "FQDN built using the zone domain and name"
  value       = [for record in aws_route53_record.apache-domain : record.fqdn]
}
