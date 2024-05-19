output "public_ip_address" {
  value = aws_instance.apache-server.public_ip
}

output "instance_dns" {
  value = aws_instance.apache-server.public_dns
}