

output "vpc_id" {
  description = "value of the VPC ID"
  value = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "list of private subnet IDs"
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "list of public subnet IDs"
  value = aws_subnet.public[*].id
}