#1a.Create VPC
resource "aws_vpc" "LabVPC" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "vpc_lab"
  }
}

#1b.Create internet gateway
resource "aws_internet_gateway" "IG_lab" {
  vpc_id = aws_vpc.LabVPC.id

  tags = {
    Name = "LabVPCInternetGateway"
  }
}

#1c.Create 2 public subnets for NAT gateway:
resource "aws_subnet" "public_subnet_lab" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.LabVPC.id

  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-lab-${count.index + 1}"
  }
}

//create 2 private subnets for EC2
resource "aws_subnet" "private_subnet_lab_ec2" {
  count                  = length(var.private_subnet_cidr_blocks_ec2)
  vpc_id                 = aws_vpc.LabVPC.id

  cidr_block             = element(var.private_subnet_cidr_blocks_ec2,count.index)
  availability_zone      = element(var.availability_zone,count.index)
  

  tags = {
    Name = "private-subnet-lab-ec2-${count.index + 1}"
  }
}

//create 2 private subnets for RDS
resource "aws_subnet" "private_subnet_lab_rds" {
  count                  = length(var.private_subnet_cidr_blocks_rds)
  vpc_id                 = aws_vpc.LabVPC.id

  cidr_block             = element(var.private_subnet_cidr_blocks_rds,count.index)
  availability_zone      = element(var.availability_zone,count.index)
  
  tags = {
    Name = "private-subnet-lab-rds-${count.index + 1}"
  }
}

resource "aws_eip" "lab" {
  vpc = true
}
//create nat gateway
resource "aws_nat_gateway" "LabVPCNATGateway" {
  
  allocation_id = aws_eip.lab.id
  subnet_id = aws_subnet.public_subnet_lab[0].id

  tags = {
    Name = "Nat-gateway"
  }
}
#1d. Create public route table
resource "aws_route_table" "public_route_table_lab" {
  vpc_id                  = aws_vpc.LabVPC.id

  route {
    cidr_block = var.aws_route_table_cidr
    gateway_id = aws_internet_gateway.IG_lab.id
  }
  tags = {
    Name = "public-route-table-lab"
  }
}

//create private route table
resource "aws_route_table" "private_route_table_lab" {
  vpc_id                  = aws_vpc.LabVPC.id
  route {
    cidr_block = var.aws_route_table_cidr
    nat_gateway_id = aws_nat_gateway.LabVPCNATGateway.id
  }
  tags = {
    Name = "private-route-table-lab"
  }
}
#1e. route associations public
resource "aws_route_table_association" "public_route_table_lab" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.public_subnet_lab.*.id, count.index)
  route_table_id = aws_route_table.public_route_table_lab.id
}

#1e. route associations private for ec2
resource "aws_route_table_association" "private_route_table_lab_ec2" {
  count          = length(var.private_subnet_cidr_blocks_ec2)
  subnet_id      = element(aws_subnet.private_subnet_lab_ec2.*.id, count.index)
  route_table_id = aws_route_table.private_route_table_lab.id
}

#1e. route associations private for rds
resource "aws_route_table_association" "private_route_table_lab_rds" {
  count          = length(var.private_subnet_cidr_blocks_rds)
  subnet_id      = element(aws_subnet.private_subnet_lab_rds.*.id, count.index)
  route_table_id = aws_route_table.private_route_table_lab.id
}