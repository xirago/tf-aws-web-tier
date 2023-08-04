output "load-balancer-url" {
  description = "URL of the deployed load balancer endpoint"
  value       = "http;//${aws_alb.frontend.dns_name}"
}
