variable "name" {
  type = string
}

variable "ecr_repo_url" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "tg_blue_arn" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

# CPU & memory
variable "cpu" {
  type    = string
  default = "512"
}

variable "memory" {
  type    = string
  default = "1024"
}

# DB env vars
variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}



variable "listener_prod_dependency" {
  type = any
}

variable "listener_test_dependency" {
  type = any
}