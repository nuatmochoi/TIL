# resource "aws_instance" "example" {
#   ami = "ami-0e1d09d8b7c751816"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.instance.id]

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo amazon-linux-extras install -y nginx
#               sudo service nginx start
#               EOF
#   tags = {
#     "Name" = "tf-example"
#   }
# }

resource "aws_security_group" "instance" {
  name = "tf-example-instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_launch_configuration" "example" {
  # name_prefix = "tf-conf-asg"
  image_id        = var.ami_id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  name =  "${substr(format("%s-%s", "${var.asg_prefix}-tg", replace(uuid(), "-", "")), 0, 32)}"
  launch_configuration = aws_launch_configuration.example.id
  # availability_zones   = data.aws_availability_zones.all.names
  target_group_arns = [aws_lb_target_group.test.arn]
  vpc_zone_identifier = [for subnet in data.aws_subnets.public.ids : subnet]

  desired_capacity = 1
  min_size = 1
  max_size = 10

  force_delete = true
  health_check_grace_period = 300
  health_check_type = "EC2"
  depends_on = [
    aws_launch_configuration.example
  ]

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  autoscaling_group_name = aws_autoscaling_group.example.name
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"
}
