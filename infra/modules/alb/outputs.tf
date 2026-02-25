############################################
# LOAD BALANCER
############################################

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

############################################
# TARGET GROUPS
############################################

output "tg_blue_arn" {
  description = "Blue target group ARN"
  value       = aws_lb_target_group.blue.arn
}

output "tg_green_arn" {
  description = "Green target group ARN"
  value       = aws_lb_target_group.green.arn
}

output "tg_blue_name" {
  description = "Blue target group name"
  value       = aws_lb_target_group.blue.name
}

output "tg_green_name" {
  description = "Green target group name"
  value       = aws_lb_target_group.green.name
}

############################################
# LISTENERS
############################################

output "listener_prod_arn" {
  description = "Production listener ARN (port 80)"
  value       = aws_lb_listener.listener_prod.arn
}

output "listener_test_arn" {
  description = "Test listener ARN (port 9000)"
  value       = aws_lb_listener.listener_test.arn
}

############################################
# DEPENDENCY OBJECTS (for ECS depends_on)
############################################

output "listener_prod_dependency" {
  description = "Listener resource object for dependency"
  value       = aws_lb_listener.listener_prod
}

output "listener_test_dependency" {
  description = "Listener resource object for dependency"
  value       = aws_lb_listener.listener_test
}