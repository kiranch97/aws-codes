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
 
# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = file("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhCLqXxlrJuGis0EeuX/Y3M6z4Z4NUorQD5p3eWjOvakMf+RjPc5GdBuC1YAznHwWfBpn1eR4vGVZkcEYpn5rlvI64L8pgWh3dIbB5nAKfd0v7PrfYSixveD0Sw2DKQdWqlQbBadR0j5Vs7b3y+BVXkSZnCSVVgsfVZqsRbAXb/5AlJtpK227VS78VMOivi1fehQ8BouxjzMRtQbGpp0QA8VRG+LSaZeZ6eeqndZYIGX7UW5UcpLk2W6Z9/Y5HWqCSaj36jbvRxqI7dHMDwXFYf/HhxSaeuJ8v4S+h/wZAQ0poP/OOo92K9xPHlROjgVHdrBCtlkM6rE93UOApgBIJP2LpWjMF2kXDTIm9/9HxGcL63tU0LPTus2cX9ZGS0SKZjmiaoQLXMdJQv5zFh+H4eeadOEyXGt9TG/GO0Xf/XxGWBt7DDjutZKzXSUUoO9wphmgbo/m7002hcY5QzzlNAyyQdcFJKs7IkMp1LyhqTvMxacXeqflqA7v1Ck9G/fNIYHFZnMtRysM6VHWeJoRSoadzSs3kJige4etv3waLcdAie6oBRDp4aGDeMAFromhCkGoR/xemI+HCzCh8yOFIREDbiX5TEwOz3otjWuEljSxbosyILkKQ0q0xSEd0rPvLL6SwEW19pj24LW7nLvpgDalFcwP8ShC5KKODeXp3BQ==")  # Adjust to your SSH public key path
}
 
# EC2 Instance
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Change to the latest AMI ID in your region
  instance_type = "t2.micro"
 
  key_name               = aws_key_pair.my_key_pair.key_name
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
 
  tags = {
    Name = "my_ec2_instance"
  }
}
