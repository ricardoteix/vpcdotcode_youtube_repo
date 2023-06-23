resource "aws_lb" "general-resources-elb" {
  name               = "elb-${var.tag-base}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security.sg-elb.id]
  subnets            = module.network.public_subnets[*].id

  enable_deletion_protection = false

  tags = {
    Name = "elb-${var.tag-base}"
    Terraformed = true
  }
}
