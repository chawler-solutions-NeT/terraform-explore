# output "public_ip_address" {
#   value = aws_instance.apache-serve[each.key].public_ip
# }

# output "instance_dns" {
#   value = aws_instance.apache-serve[each.key].public_dns
# }

# output "instance_id" {
#   value = aws_instance.apache-serve[each.key].id
# }

# # output "ami_from_instance" {
# #   value = aws_ami_from_instance.apache_copy.id
# # }

# output "security_group_id" {
#   value = aws_security_group.apache-serve[each.key].id
# }