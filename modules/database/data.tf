
data "aws_security_group" "LabVPCRDSSG" {
  filter {
    name = "tag:Name"
    values = ["LabVPCRDSSG"]
  }
}

data "aws_subnet" "private_subnet_lab_rds" {
  count = 2
  filter {
    name = "tag:Name"
    values = ["private-subnet-lab-rds-${count.index + 1}"]
  }
}