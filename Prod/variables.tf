variable "aws_region" {
  description = "vpc_right_way"
  type        = string
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "available zone"
  default = ["us-west-2a", "us-west-2b"]
}

variable "instance_ami" {
  description = "instance ami"
  default = "ami-0cea098ed2ac54925" 
}

