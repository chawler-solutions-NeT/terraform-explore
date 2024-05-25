output "vpc_cidr_block" {
  value = aws_vpc.csnet_vpc.cidr_block
}

output "vpc_id" {
  value = aws_vpc.csnet_vpc.id
}

output "vpc_arn" {
  value = aws_vpc.csnet_vpc.arn
}

output "public_sub_1" {
  value = aws_subnet.public_sub_1.id
}

output "public_sub_2" {
  value = aws_subnet.public_sub_2.id
}