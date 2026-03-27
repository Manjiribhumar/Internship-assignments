variable "vpc_id" {}

resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}
