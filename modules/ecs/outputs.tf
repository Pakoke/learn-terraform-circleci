output "elb_default_dns" {
  value = aws_lb.front_end.dns_name
}