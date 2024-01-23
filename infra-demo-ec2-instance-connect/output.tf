
output "ec2-acesso-id" {
  value = aws_iam_access_key.acesso-ec2.id
}

output "ec2-acesso-secret" {
  value = aws_iam_access_key.acesso-ec2.secret
  sensitive = true
}

output "ec2-connect-cmd" {
  value = [
    for instance in aws_instance.projeto :
    "aws ec2-instance-connect ssh --instance-id ${instance.id} --os-user ubuntu --profile ${var.profile}"
  ]
}

output "elb-dns" {
  value = aws_lb.general-resources-elb.dns_name
}


output "projeto-rds-host" {
  value = var.use-rds ? aws_db_instance.projeto-rds[0].address : "RDS desativado"
}
