# Arquivo com a definição das variáveis. O arquivo poderia ter qualquer outro nome, ex. valores.tf

variable "region" {
  description = "Região da AWS para provisionamento"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "Profile com as credenciais criadas no IAM"
  type = string
}

variable "tag-base" {
  description = "Nome utilizado para nomenclaruras no projeto"
  type        = string
  default     = "projeto"
}

variable "use-nat-gateway" {
  description = "Especifica se serão criados NAT Gateways para cada Subnet pública."
  type = bool
  default = false
}

variable "user-data-file" {
  description = "Script que será executado ao subir a instância"
  type        = string
  default     = "wordpress_user_data.sh"
}

variable "ec2-key-pair" {
  description = "Nome da chave para acesso SSH"
  type        = string
}

variable "ec2-instance-type" {
  description = "Tipo de instância"
  type        = string
}

variable "ec2-ebs-size" {
  description = "Tipo de instância"
  type        = number
  default = 8
}

variable "ec2-amis" {
  description = "AMIs"
  type        = list(string)
  default     = ["ami-053b0d53c279acc90"] 
}

variable "ec2-ami-linux" {
  description = "AMI linux base"
  type        = string
  default     = "ami-053b0d53c279acc90" # Canonical, Ubuntu, 22.04 LTS
}

variable "ec2-ami-windows" {
  description = "AMI win base"
  type        = string
  default     = "ami-04132f301c3e4f138" # Microsoft Windows Server 2022 
}

variable "health_check" {
   type = map(string)
   default = {
      "timeout"  = "10"
      "interval" = "20"
      "path"     = "/"
      "port"     = "80"
      "unhealthy_threshold" = "2"
      "healthy_threshold" = "3"
    }
}

# RDS
variable "rds-identifier" {
  description = "Tipo da instância do RDS"
  type        = string
  default     = "projeto-db"
}

variable "rds-instance-type" {
  description = "Tipo da instância do RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "rds-database-name" {
  description = "Nome do schema criado inicialmente para usar no Projeto"
  type        = string
  default     = "projeto_db"
}

variable "rds-username" {
  description = "Nome do usuário administrador da instância RDS"
  type        = string
  # Veja o arquivo terraform.tfvars.exemplo para definir um valor fixo para esta variável.
}

variable "rds-password" {
  description = "Senha do usuário administrador da instância RDS"
  type        = string
  # default     = "nao colocar valor padrão aqui" # Não deixar padrão para versionar com git.
  # Veja o arquivo terraform.tfvars.exemplo para definir um valor fixo para esta variável.
}

variable "use-rds" {
  description = "Define se o RDS será criado ou não"
  type        = bool
  default     = false
}
