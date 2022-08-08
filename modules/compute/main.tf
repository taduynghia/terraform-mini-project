#2. Create EC2
resource "aws_instance" "ec2-project" {
  count           = length(data.aws_subnet.private_subnet_lab_ec2)
  ami             = var.instance_ami
  instance_type   = var.instance_type
  //export AWS_ACCESS_KEY_ID =${var.aws_key_id}
  //export AWS_ACCESS_KEY_ID =AKIA5I6644IMEWFJTGUY
  //export AWS_SECRET_ACCESS_KEY =${var.aws_access_key}
  //export AWS_SECRET_ACCESS_KEY =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
  //export AWS_DEFAULT_REGION =${var.aws_region}
  //export AWS_DEFAULT_REGION =us-west-1
  #!/bin/bash 
  user_data       = <<-EOF

  sudo yum update -y
  sudo yum install -y python3
  
  export AWS_ACCESS_KEY_ID =${var.aws_key_id}
  export AWS_SECRET_ACCESS_KEY =${var.aws_access_key}
  export AWS_DEFAULT_REGION =${var.aws_region}
  aws s3 cp s3://us-west-2-aws-training/awsu-spl/SPL-TF-200-NWCDVW-1/1.0.6.prod/scripts/vpcapp.zip .
  unzip vpcapp.zip
  cd vpcapp
  pip3 install -r requirements.txt

  export DATABASE_HOST=${data.aws_db_instance.db-endpoint.address}
  export DATABASE_USER=admin
  export DATABASE_PASSWORD=testingrdscluster
  export DATABASE_DB_NAME=Population
  cd loaddatabase
  python3 database_populate.py
  cd ..
  python3 application.py
  EOF
  subnet_id       = element(data.aws_subnet.private_subnet_lab_ec2.*.id, count.index)
  security_groups = [data.aws_security_group.LabVPCEC2SG.id]
  tags = {
    Name = "ec2-project-${count.index + 1}"
  }
}

#3a. create load balancer
resource "aws_lb" "lb_project" {
  
  name               = "lb-project-way"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in data.aws_subnet.public_subnet_lab :subnet.id] 
  security_groups    = [data.aws_security_group.LabVPCALBSG.id]
}

#3b.create target group
resource "aws_lb_target_group" "project" {

  name        = "tg-project"
  port        = 8443
  target_type = "instance"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc_id.id
}

#3c .create target group attachment instance ec2
resource "aws_alb_target_group_attachment" "att_tg" {
  count           = length(data.aws_subnet.private_subnet_lab_ec2)
  target_group_arn = aws_lb_target_group.project.arn
  target_id        = aws_instance.ec2-project[count.index].id
  port             = 8443
}

#3d create listener
resource "aws_alb_listener" "project" {
  load_balancer_arn = aws_lb.lb_project.arn
  port              =  80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project.arn
  }
}

resource "aws_lb_listener_rule" "lsr" {
  listener_arn = aws_alb_listener.project.arn
  priority = 100
  action {
    type    = "forward"
    target_group_arn = aws_lb_target_group.project.arn
  }
  condition {
    path_pattern{
      values = ["/"]
    }
  }
}
 