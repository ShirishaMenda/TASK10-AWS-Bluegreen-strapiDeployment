###############################################
# VPC / NETWORK OUTPUTS
###############################################

output "vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}

output "alb_public_subnets" {
  description = "Public subnets used by ALB (1 per AZ)"
  value       = data.aws_subnets.alb_subnets.ids
}

output "private_subnets" {
  description = "Private subnets created by the VPC module"
  value       = module.vpc.private_subnet_ids
}

###############################################
# ALB OUTPUTS
###############################################

output "alb_dns" {
  description = "Public DNS of the ALB"
  value       = module.alb.alb_dns
}

###############################################
# ECS OUTPUTS
###############################################

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}


###############################################
# ECR OUTPUTS
###############################################

output "ecr_repo_url" {
  description = "URL of the ECR repository"
  value       = module.ecr.repository_url
}

###############################################
# RDS OUTPUTS
###############################################

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.rds_endpoint
}

###############################################
# CODEDEPLOY OUTPUTS
###############################################

output "codedeploy_app_name" {
  value = module.codedeploy.codedeploy_app
}

output "codedeploy_deployment_group_name" {
  value = module.codedeploy.codedeploy_deployment_group
}