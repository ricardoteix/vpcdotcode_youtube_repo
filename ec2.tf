 # Criando variáveis no arquivo projeto_user_data.sh
 data "template_file" "user-data-script" {
  template = file(var.user-data-file)
  vars = {
    region = "${var.region}"
  }
}

variable "azs" {
  type = list(string)
  default = ["a", "b"]
}


# Criando uma instância EC2
resource "aws_instance" "projeto" {
  count = length(var.ec2-amis)
  ami = var.ec2-amis[count.index]
  instance_type = "${var.ec2-instance-type}"
  availability_zone = "${var.region}${var.azs[count.index]}"
  key_name = "${var.ec2-key-pair}"

  network_interface {
    device_index = 0 # ordem da interface 
    network_interface_id = aws_network_interface.nic-projeto-instance[count.index].id
  }

  # EBS root
  root_block_device {
    volume_size = var.ec2-ebs-size
    volume_type = "gp2"
  }

  # Usando renderização do arquivo pelo template_file
  user_data = data.template_file.user-data-script.rendered  

  tags = {
      Name = "${var.tag-base}"
      Terraformed = true
  }
}

# Criando Network Interface da instância
resource "aws_network_interface" "nic-projeto-instance" {
  count = length(var.ec2-amis)
  subnet_id       = module.network.private_subnets[count.index].id
  private_ips     = ["10.0.${count.index + 1}.50"]
  security_groups = [module.security.sg-web.id]
}

resource "aws_lb_target_group" "tg-projeto" {
  # for_each  = [aws_lb.projeto-elb.name]
  name     = "tg-${var.tag-base}"
  target_type   = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
  health_check {
      healthy_threshold   = var.health_check["healthy_threshold"]
      interval            = var.health_check["interval"]
      unhealthy_threshold = var.health_check["unhealthy_threshold"]
      timeout             = var.health_check["timeout"]
      path                = var.health_check["path"]
      port                = var.health_check["port"]
      matcher             = "200,302"
  }
}


# Attach the target group for "test" ALB
resource "aws_lb_target_group_attachment" "tg_attachment_projeto-elb" {  
  count = length(var.ec2-amis)
  target_group_arn = aws_lb_target_group.tg-projeto.arn
  target_id        = aws_instance.projeto[count.index].id
  port             = 80
}

# Listener rule for HTTP traffic on each of the ALBs
resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn    = aws_lb.general-resources-elb.arn
  port                 = "80"
  protocol             = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.tg-projeto.arn
    type             = "forward"
  }
}
