#This block will create VPC
resource "aws_vpc" "csnet_vpc" {
  cidr_block       = "10.100.0.0/16"  
  instance_tenancy = "default"

  tags = {
    Name = "csnet-terraform-demo-vpc"
  }
}

#This code block will create subnet 1
resource "aws_subnet" "public_sub_1" {
  vpc_id     = aws_vpc.csnet_vpc.id
  cidr_block = "10.100.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-sub-1"
  }
}

#This code block provisions public sub 2
resource "aws_subnet" "public_sub_2" {
  vpc_id     = aws_vpc.csnet_vpc.id
  cidr_block = "10.100.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-sub-2"
  }
}

#This code block provisions private sub 1
resource "aws_subnet" "private_sub_1" {
  vpc_id     = aws_vpc.csnet_vpc.id
  cidr_block = "10.100.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-sub-1"
  }
}

#This code block provisions private sub 2
resource "aws_subnet" "private_sub_2" {
  vpc_id     = aws_vpc.csnet_vpc.id
  cidr_block = "10.100.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-sub-2"
  }
}

#This code block will provision private RTB
resource "aws_route_table" "priv_rtb" {
  vpc_id = aws_vpc.csnet_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.csnet_ngw.id
  }

  tags = {
    Name = "private-rtb"
  }
  lifecycle {
    ignore_changes = all
  }
}

#This code block will provision public RTB
resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.csnet_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.csnet_igw.id
  }

  tags = {
    Name = "public-rtb"
  }
}

#Route table association of public sub 1
resource "aws_route_table_association" "public_sub_1" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.pub_rtb.id
}

#Route table association of public sub 2
resource "aws_route_table_association" "public_sub_2" {
  subnet_id      = aws_subnet.public_sub_2.id
  route_table_id = aws_route_table.pub_rtb.id
}

#Route table association of private sub 1
resource "aws_route_table_association" "private_sub_1" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.priv_rtb.id
}

#Route table association of private sub 2
resource "aws_route_table_association" "private_sub_2" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.priv_rtb.id
}

#Code to provision internet gateway
resource "aws_internet_gateway" "csnet_igw" {
  vpc_id = aws_vpc.csnet_vpc.id

  tags = {
    Name = "csnet-igw"
  }
}

#Code to provision elastic IP
resource "aws_eip" "csnet_eip" {
  domain   = "vpc"

  tags = {
    Name = "csnet-eip"
  }
}

#Code block to provision nat gatway
resource "aws_nat_gateway" "csnet_ngw" {
  allocation_id = aws_eip.csnet_eip.id
  subnet_id     = aws_subnet.public_sub_1.id

  tags = {
    Name = "csnet-NAT"
  }

  depends_on = [aws_internet_gateway.csnet_igw]
}