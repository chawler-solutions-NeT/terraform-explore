output "vpc_id" {
  value = aws_vpc.csnet_vpc.cidr_block
}