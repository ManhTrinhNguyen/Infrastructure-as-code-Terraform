output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
} 
output "dev-subnet-id" {
  value = module.myapp-subnet.subnet.id
}

output "ec2_public_IP" {
  value = module.myapp-server.server.public_ip
}
