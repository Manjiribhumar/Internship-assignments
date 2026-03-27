variable "private_subnets" {}
variable "instance_sg" {}
variable "target_group_arn" {}

resource "aws_launch_template" "lt" {
  name_prefix   = "lt"
  image_id      = "ami-0f58b397bc5c1f2e8"
  instance_type = "t2.micro"

  network_interfaces {
    security_groups = [var.instance_sg]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum install -y httpd
systemctl start httpd
echo "Hello from AutoScaling" > /var/www/html/index.html
EOF
)
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
