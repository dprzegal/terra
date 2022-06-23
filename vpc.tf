resource "aws_vpc" "main_vpc" {
  cidr_block = "${var.vpc_cidr}" #"192.168.0.0/16"
  instance_tenancy = "default"

  enable_dns_support = "true"

  tags = {
    Name = "main_vpc_dpr"
    Terraform   = "true"
    Environment = "dev"
  }
}


# Subnets

#public subnets
resource "aws_subnet" "main-public-1" {
vpc_id = "${aws_vpc.main_vpc.id}"
cidr_block = "${var.public_subnets[0]}"   #"192.168.101.0/24"
map_public_ip_on_launch = "true"
availability_zone = "${var.AWS_REGION}a"
tags = {
  Name = "main-public-1"
}
}
resource "aws_subnet" "main-public-2" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "${var.public_subnets[1]}"   #"192.168.102.0/24"
map_public_ip_on_launch = "true"
availability_zone = "${var.AWS_REGION}b"
tags = {
  Name = "main-public-2"
}
}
resource "aws_subnet" "main-public-3" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "${var.public_subnets[2]}"   #"192.168.103.0/24"
map_public_ip_on_launch = "true"
availability_zone = "${var.AWS_REGION}c"
tags = {
  Name = "main-public-3"
}
}


#private subnets
resource "aws_subnet" "main-private-1" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "${var.private_subnets[0]}"   #"192.168.1.0/24"
map_public_ip_on_launch = "false"
availability_zone = "${var.AWS_REGION}a"
tags = {
  Name = "main-private-1"
}
}
resource "aws_subnet" "main-private-2" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "${var.private_subnets[1]}"   #"192.168.2.0/24"
map_public_ip_on_launch = "false"
availability_zone = "${var.AWS_REGION}b"
tags = {
  Name = "main-private-2"
}
}
resource "aws_subnet" "main-private-3" {
vpc_id = aws_vpc.main_vpc.id
cidr_block = "${var.private_subnets[2]}"   #"192.168.3.0/24"
map_public_ip_on_launch = "false"
availability_zone = "${var.AWS_REGION}c"
tags = {
  Name = "main-private-3"
}
}

#Create AWS Internet Gateway
resource "aws_internet_gateway" "terra_gateway" {
  vpc_id = "${aws_vpc.main_vpc.id}"
  tags = {
    Name = "internet gw"
  }
}

#Creating Route Table
resource "aws_route_table" "out_route" {
    vpc_id = "${aws_vpc.main_vpc.id}"
route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.terra_gateway.id}"
    }
tags = {
        Name = "Route to internet"
    }
}
resource "aws_route_table_association" "rtpub1" {
    subnet_id = "${aws_subnet.main-public-1.id}"
    route_table_id = "${aws_route_table.out_route.id}"
}
resource "aws_route_table_association" "rtpub2" {
    subnet_id = "${aws_subnet.main-public-2.id}"
    route_table_id = "${aws_route_table.out_route.id}"
}
resource "aws_route_table_association" "rtpub3" {
    subnet_id = "${aws_subnet.main-public-3.id}"
    route_table_id = "${aws_route_table.out_route.id}"
}