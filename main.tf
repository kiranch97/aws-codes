# Provider
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}
 
# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
 
  tags = {
    Name = "my_vpc"
  }
}
 
# Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
 
  tags = {
    Name = "my_subnet"
  }
}
 
# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
 
  tags = {
    Name = "my_internet_gateway"
  }
}
 
# Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
 
  tags = {
    Name = "my_route_table"
  }
}
 
# Route Table Association
resource "aws_route_table_association" "my_rta" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}
 
# Security Group
resource "aws_security_group" "my_sg" {
  vpc_id = aws_vpc.my_vpc.id
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
  tags = {
    Name = "my_security_group"
  }
}
 
 
# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0e86e20dae9224db8"  # Change to the latest AMI ID in your region
  instance_type = "t2.micro"
 
  key_name               = "kiran-keypair"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
 
  tags = {
    Name = "my_ec2_instance"
  }
}
