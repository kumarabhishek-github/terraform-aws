resource "aws_vpc" "custom-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main-vpc"
  }
}
resource "aws_subnet" "public-subnet-1" {
  vpc_id = aws_vpc.custom-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
    tags = {
    Name ="public-subnet-1" 
  }
  
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id = aws_vpc.custom-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
    tags = {
    Name ="public-subnet-2" 
  }
  
}
resource "aws_internet_gateway" "custom-igw" {
  vpc_id = aws_vpc.custom-vpc.id
  tags = {
    Name = "custom-igw"
  }
}
resource "aws_route_table" "custom-route-table" {
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block           = aws_vpc.custom-vpc.cidr_block
    gateway_id            = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw.id
  }
    tags = {
    Name ="routable-rt" 
  }
  
}
resource "aws_route_table_association" "pub-sub-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.custom-route-table.id
}
resource "aws_route_table_association" "pub-sub-2" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.custom-route-table.id
}

resource "aws_security_group" "web_sg" {
 name        = "app-server"
 vpc_id      = aws_vpc.custom-vpc.id
ingress {
   description = "HTTPS"
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
    description = "HTTP"
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
}
resource "aws_instance" "web" {
  ami           = var.ami
  security_groups = [ aws_security_group.web_sg.id ]
  instance_type = var.instance_type
  availability_zone = var.availability_zoneb
  tags = {
    Name = "web-server"
  }
  subnet_id = aws_subnet.public-subnet-1.id
}
resource "aws_instance" "app" {
  ami           = var.ami
  security_groups = [ aws_security_group.web_sg.id ]
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  tags = {
    Name = "app-server"
  }
  subnet_id = aws_subnet.public-subnet-2.id
}
