provider "aws" {
  region = "us-west-1"
}

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env-prefix" {}
variable "availability_zone" {}
variable "my_ip" {}
variable "public_key_location" {}
variable "instance_type" {}


resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  
  tags = {
    Name: "${var.env-prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name: "${var.env-prefix}-subnet"
  }
}

# resource "aws_route_table" "myapp-routable" {
#     vpc_id = aws_vpc.myapp-vpc.id 

#     route {
#       cidr_block = "0.0.0.0/0"
#       gateway_id = aws_internet_gateway.myapp-igt.id
#     }

#     tags = {
#       Name: "${var.env-prefix}-rtb"
#     }
# } I DON"T NEED IT BCS I WANT TO USE DEFAULT ROUTE TABLE

resource "aws_default_route_table" "myapp-default-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igt.id
  }

  tags = {
      Name: "${var.env-prefix}-rtb"
    }
}

resource "aws_internet_gateway" "myapp-igt" {
  vpc_id = aws_vpc.myapp-vpc.id 

  tags = {
    Name: "${var.env-prefix}-igw"
  }
}
 
# resource "aws_route_table_association" "myapp-rtb-association" {
# subnet_id = aws_subnet.myapp-subnet-1.id
# route_table_id = aws_route_table.myapp-routable.id
# } I DON"T NEED IT BCS I WANT TO USE DEFAULT ROUTE TABLE

resource "aws_security_group" "myapp-sg" {
  vpc_id = aws_vpc.myapp-vpc.id
  description = "Allow inbound traffic and outbout traffic"
  tags = {
    Name: "${var.env-prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "myapp-ingress-8080" {
  security_group_id = aws_security_group.myapp-sg.id
  from_port = 8080
  to_port = 8080
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "TCP"
}

resource "aws_vpc_security_group_ingress_rule" "myapp-ingress-22" {
  security_group_id = aws_security_group.myapp-sg.id
  from_port = 22
  to_port = 22
  cidr_ipv4 = var.my_ip
  ip_protocol = "TCP"
}

resource "aws_vpc_security_group_egress_rule" "myapp-egress" {
  security_group_id = aws_security_group.myapp-sg.id 
  ip_protocol = "-1" 
  cidr_ipv4 = "0.0.0.0/0"
}

data "aws_ami" "latest-amazon-image" {
  owners = [ "amazon" ]
  most_recent = true

  filter {
    name = "name"
    values = ["Deep Learning Proprietary Nvidia Driver AMI GPU TensorFlow 2.16 (Amazon Linux 2) 20240729"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  
  subnet_id = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.availability_zone

  associate_public_ip_address = true

  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry_script.sh")

  user_data_replace_on_change = true
  tags = {
    Name = "${var.env-prefix}-server"
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
}
output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
} 
output "dev-subnet-id" {
  value = aws_subnet.myapp-subnet-1.id
}

output "public_IP" {
  value = aws_instance.myapp-server.public_ip
}

