output "ec2_privates_ip_address" {
  value = { for service, i in aws_instance.reto-backend-pragma-java : service => i.private_ip }
}

output "ec2_publics_ip_address" {
  value = { for service, i in aws_instance.reto-backend-pragma-java : service => i.public_ip }
}

output "ssh-path" {
  value = {
    for service, i in aws_instance.reto-backend-pragma-java : service =>
    "ssh -i /c/Users/Usuario/.ssh/id_rsa ubuntu@${i.public_ip}"
  }

}


output "jenkins-url" {
  value = {
    for service, i in aws_instance.reto-backend-pragma-java : service =>
    "http://${i.public_ip}:8182"
  }

}


output "asset-mongo-db-url" {
  value = {
    for service, i in aws_instance.reto-backend-pragma-java : service =>
    "http://${i.public_ip}:27018"
  }

}


output "assignee-mongo-db-url" {
  value = {
    for service, i in aws_instance.reto-backend-pragma-java : service =>
    "http://${i.public_ip}:27017"
  }

}

