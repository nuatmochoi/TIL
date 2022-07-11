output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "subnet_list" {
  value = data.aws_subnets.public
}


output "tg-test" {
  value = aws_lb_target_group.test.arn
}
