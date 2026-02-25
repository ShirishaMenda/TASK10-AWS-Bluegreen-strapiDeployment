variable "name" {
  type = string
}

variable "codedeploy_role_arn" {
  type = string
}

# ECS service wiring
variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

# ALB listeners
variable "listener_prod_arn" {
  type = string
}

variable "listener_test_arn" {
  type = string
}

# Target groups
variable "tg_blue_name" {
  type = string
}

variable "tg_green_name" {
  type = string
}