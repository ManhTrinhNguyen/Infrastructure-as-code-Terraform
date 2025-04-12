output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
} 
output "dev-subnet-id" {
  value = module.myapp-subnet.subnet.id
}

output "public_IP" {
  value = aws_instance.myapp-server.public_ip
}
