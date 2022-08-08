variable "vpc_id" {
  description = "vpc_id"
  type = string
  default = "aws_vpc.LabVPC.id"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr_blocks_ec2" {
  description = "Aivailable cidr blocks for private subnets ec2"
  type = list(string)
  default = [ "10.0.11.0/24","10.0.12.0/24"]
}

variable "private_subnet_cidr_blocks_rds" {
  description = "Aivailable cidr blocks for private subnets rds"
  type = list(string)
  default = [ "10.0.13.0/24","10.0.14.0/24"]
}

variable "aws_route_table_cidr" {
  type    = string
  default = "0.0.0.0/0"

}
variable "availability_zone" {
  type    = list(string)
}


