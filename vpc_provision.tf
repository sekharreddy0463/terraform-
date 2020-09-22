resource "aws_vpc" "eu_west_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
      Name = "EU_WEST_LONDON"
    }
}
resource "aws_subnet" "PublicSubnet" {
  vpc_id = aws_vpc.eu_west_vpc.id
  cidr_block = var.public_subnet
  tags = {
        Name = "Public_Subnet_eu_west"
  }
 availability_zone = data.aws_availability_zones.available.names[0]
}
resource "aws_subnet" "PrivateSubnet" {
  vpc_id = aws_vpc.eu_west_vpc.id
  cidr_block = var.private_subnet
  tags = {
        Name = "Private_Subnet_eu_west"
  }
 availability_zone = data.aws_availability_zones.available.names[0]
}
 resource "aws_internet_gateway" "eu_west_igw" {
  vpc_id = aws_vpc.eu_west_vpc.id
}
resource "aws_route_table" "public_eu_west_RT" {
  vpc_id = aws_vpc.eu_west_vpc.id
  tags = {
      Name = "Public_RT"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eu_west_igw.id
    }
}
resource "aws_route_table_association" "PublicSubnet" {
    subnet_id = aws_subnet.PublicSubnet.id
    route_table_id = aws_route_table.public_eu_west_RT.id
}
resource "aws_route_table" "private_eu_west_RT" {
  vpc_id = aws_vpc.eu_west_vpc.id
  tags = {
      Name = "Private_RT"
  }
}
resource "aws_route_table_association" "PrivateSubnet" {
    subnet_id = aws_subnet.PrivateSubnet.id
    route_table_id = aws_route_table.private_eu_west_RT.id
}
resource "aws_network_acl" "Public_Nacl" {
   vpc_id = aws_vpc.eu_west_vpc.id
   subnet_ids = [ aws_subnet.PublicSubnet.id ]
   egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags = {
    Name = "eu_west_Public"
    } 
}
resource "aws_network_acl" "Private_Nacl" {
   vpc_id = aws_vpc.eu_west_vpc.id
   subnet_ids = [ aws_subnet.PrivateSubnet.id ]

    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block = var.private_subnet
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block = var.private_subnet
        from_port = 0
        to_port = 0
    }
    tags = {
    Name = "eu_west_Private"
    } 
}




