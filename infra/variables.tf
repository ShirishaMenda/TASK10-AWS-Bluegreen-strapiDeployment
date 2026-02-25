###############################################
# PROJECT CONFIGURATION
###############################################

variable "project_name" {
  description = "Prefix name for all AWS resources"
  type        = string
}

###############################################
# DATABASE CONFIGURATION
###############################################

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

###############################################
# ECS CONFIGURATION
###############################################

variable "ecs_task_role_arn" {
  description = "IAM role ARN used by ECS task execution"
  type        = string
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

###############################################
# CODEDEPLOY CONFIGURATION
###############################################

variable "codedeploy_role_arn" {
  description = "IAM role used by CodeDeploy for ECS blue/green deployments"
  type        = string
}