
variable "instance_type" {
  description = "Type of EC2 instance use"
  default     = "t2.micro"
  type        = string
}

variable "instance_ami" {
  type    = string
}

variable "aws_key_id" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_region" {
  type =string
}