#1f. Create security group 1
resource "aws_security_group" "LabVPCALBSG" {
  vpc_id = aws_vpc.LabVPC.id
  name   = "allow web access"

  ingress {
    from_port   = 0
    to_port     = 65535
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
   Name = "LabVPCALBSG"
 }

}

#1f. Create security group 2
resource "aws_security_group" "LabVPCEC2SG" {
  vpc_id = aws_vpc.LabVPC.id
  name   = "allow ALB to access EC2 instances"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.LabVPCALBSG.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.LabVPCALBSG.id}"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.LabVPCALBSG.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "LabVPCEC2SG"
  }
}

//create security group 3
resource "aws_security_group" "LabVPCRDSSG" {
  vpc_id = aws_vpc.LabVPC.id
  name   = "allow application to access the RDS instances"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.LabVPCEC2SG.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LabVPCRDSSG"
  }
}