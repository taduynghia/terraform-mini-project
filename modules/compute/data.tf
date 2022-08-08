data "aws_vpc" "vpc_id" {
  filter {
    name = "tag:Name"
    values = ["vpc_lab"]
  }
}
data "aws_db_instance" "db-endpoint" {
  db_instance_identifier = "labvpcdbcluster"
}

data "aws_subnet" "public_subnet_lab" {
  count = 2
  filter {
    name = "tag:Name"
    values = ["public-subnet-lab-${count.index + 1}"]
  }
}
data "aws_subnet" "private_subnet_lab_ec2" {
  count = 2
  filter {
    name = "tag:Name"
    values = ["private-subnet-lab-ec2-${count.index + 1}"]
  }
}

data "aws_subnet" "private_subnet_lab_rds" {
  count = 2
  filter {
    name = "tag:Name"
    values = ["private-subnet-lab-rds-${count.index + 1}"]
  }
}
data "aws_security_group" "LabVPCALBSG" {
  filter {
    name = "tag:Name"
    values = ["LabVPCALBSG"]
  }
}

data "aws_security_group" "LabVPCEC2SG" {
  filter {
    name = "tag:Name"
    values = ["LabVPCEC2SG"]
  }
}
