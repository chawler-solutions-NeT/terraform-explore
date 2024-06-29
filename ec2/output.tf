output "public_ip_address" {
  value = aws_instance.apache-server[0].public_ip
}

output "instance_dns" {
  value = aws_instance.apache-server[0].public_dns
}

output "instance_id" {
  value = aws_instance.apache-server[0].id
}

# output "ami_from_instance" {
#   value = aws_ami_from_instance.apache_copy.id
# }

output "security_group_id" {
  value = aws_security_group.apache-server[0].id
}