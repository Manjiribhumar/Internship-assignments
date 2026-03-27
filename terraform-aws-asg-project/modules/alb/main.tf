variable "vpc_id" {}
variable "public_subnets" {}
variable "sg_id" {}

resource "aws_lb" "alb" {
  name               = "app-lb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.sg_id]
}

resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}
