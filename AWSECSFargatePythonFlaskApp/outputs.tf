output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = "http://${aws_lb.monitoring-app.dns_name}/"
}

output "monitoring_status" {
  description = "The URL Monitoring Status Path"
  value       = "http://${aws_lb.monitoring-app.dns_name}/status"
}

output "alb_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.monitoring-app.name
}

output "alb_arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(aws_lb.monitoring-app.arn, "")
}