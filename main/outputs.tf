
output "ec2_privates_ip_address" {
  value = { for service, i in aws_instance.reto-backend-pragma-java : service => i.private_ip }
}

output "ec2_publics_ip_address" {
  value = { for service, i in aws_instance.reto-backend-pragma-java : service => i.public_ip }
}

