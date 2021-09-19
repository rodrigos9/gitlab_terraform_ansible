output "Instance-Public-IP" {
  value = aws_instance.gitlab.public_ip
}