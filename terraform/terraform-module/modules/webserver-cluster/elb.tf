data "aws_subnets" "public" {
  filter {
    name = "tag:Name"
    values = ["redis-test-subnet-public*"]
  }
}

data "aws_availability_zones" "all" {
  state = "available"
}

resource "aws_lb" "example" {
  name               = "terraform-asg-example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [for subnet in data.aws_subnets.public.ids : subnet]
 
  tags = {
    Environment = "production"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}

resource "aws_lb_target_group" "test" {
  name     = "${substr(format("%s-%s", "${var.prefix}-tg", replace(uuid(), "-", "")), 0, 32)}"
  port     = 8080
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id


  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.example.id
  lb_target_group_arn = aws_lb_target_group.test.arn
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"
  vpc_id      = var.vpc_id
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

