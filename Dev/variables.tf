variable "aws_region" {
  description = "vpc_project"
  type        = string
  default     = "us-west-1"
}

variable "availability_zone" {
  description = "available zone"
  default     = ["us-west-1a", "us-west-1b"]
}

variable "instance_ami" {
  description = "instance ami"
  default     = "ami-0e4d9ed95865f3b40"
}

