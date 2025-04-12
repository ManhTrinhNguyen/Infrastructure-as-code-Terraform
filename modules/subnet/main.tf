
resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name: "${var.env-prefix}-subnet"
  }
}

resource "aws_default_route_table" "myapp-default-rtb" {
  default_route_table_id = var.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igt.id
  }

  tags = {
      Name: "${var.env-prefix}-rtb"
    }
}


resource "aws_internet_gateway" "myapp-igt" {
  vpc_id = var.vpc_id 

  tags = {
    Name: "${var.env-prefix}-igw"
  }
}
 
# resource "aws_route_table_association" "myapp-rtb-association" {
# subnet_id = aws_subnet.myapp-subnet-1.id
# route_table_id = aws_route_table.myapp-routable.id
# } I DON"T NEED IT BCS I WANT TO USE DEFAULT ROUTE TABLE



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


