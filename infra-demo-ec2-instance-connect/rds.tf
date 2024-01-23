# Criando Subnet Group para RDS
resource "aws_db_subnet_group" "projeto-sn-db-group" {
  count = var.use-rds ? 1 : 0
  name       = "${var.tag-base}-sn-db-group"
  subnet_ids = module.network.private_subnets[*].id
}


# Criando Instância do RDS
resource "aws_db_instance" "projeto-rds" {
  count = var.use-rds ? 1 : 0
  identifier = var.rds-identifier
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.rds-instance-type
  db_name                 = var.rds-database-name # Nome do schema criado inicialmente para usar no projeto
  username             = var.rds-username
  password             = var.rds-password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true # Para uso em produção, considerar mudar o valor para false 
  final_snapshot_identifier = "${var.rds-identifier}-bkp"
  publicly_accessible = false
  vpc_security_group_ids = [module.security.sg-db.id]
  db_subnet_group_name    = aws_db_subnet_group.projeto-sn-db-group[count.index].id
  tags = {
    Name = "${var.tag-base}-rds"
  }
}