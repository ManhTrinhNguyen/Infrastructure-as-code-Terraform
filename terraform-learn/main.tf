provider "aws" {
  region = "us-west-1"
  access_key = ""
  secret_key = ""
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}
variable "subnet_cidr_block" {
  description = "subnet cidr block"
}
resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-west-1"
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc
  cidr_block = "172.31.48.0/20"
  availability_zone = "us-west-1"
}
 
output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
} 

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}