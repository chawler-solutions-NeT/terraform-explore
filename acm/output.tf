output "certificate_arn" {
    value = aws_acm_certificate.cert.arn
}

output "validation_option" {
    value = aws_acm_certificate.cert.validation_option
}
