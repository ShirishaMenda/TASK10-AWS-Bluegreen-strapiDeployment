##########################################

# DEFAULT VPC

##########################################

data "aws_vpc" "default" {
default = true
}

##########################################

# ALB SAFE PUBLIC SUBNETS (1 PER AZ)

##########################################

data "aws_subnets" "alb_subnets" {
filter {
name   = "default-for-az"
values = ["true"]
}

filter {
name   = "vpc-id"
values = [data.aws_vpc.default.id]
}
}

##########################################

# MODULE: VPC ( PRIVATE SUBNETS + NAT )

##########################################

module "vpc" {
source = "./modules/vpc"
name   = var.project_name
vpc_id = data.aws_vpc.default.id
}

##########################################

# MODULE: SECURITY GROUPS

##########################################

module "security_groups" {
source = "./modules/security-groups"
name   = var.project_name
vpc_id = data.aws_vpc.default.id
}

##########################################

# MODULE: ECR

##########################################

module "ecr" {
source = "./modules/ecr"
name   = "${var.project_name}-ecr"
}

##########################################

# MODULE: RDS

##########################################

module "rds" {
source          = "./modules/rds"
name            = var.project_name
private_subnets = module.vpc.private_subnet_ids
rds_sg_id       = module.security_groups.rds_sg_id

db_name     = var.db_name
db_username = var.db_username
db_password = var.db_password
}

##########################################

# MODULE: ALB (Blue/Green)

##########################################

module "alb" {
source = "./modules/alb"

name           = var.project_name
vpc_id         = data.aws_vpc.default.id
public_subnets = data.aws_subnets.alb_subnets.ids
alb_sg_id      = module.security_groups.alb_sg_id
}

##########################################

# MODULE: ECS (Fargate + Blue/Green)

##########################################

module "ecs" {
source = "./modules/ecs"

name              = var.project_name
ecr_repo_url      = module.ecr.repository_url
ecs_task_role_arn = var.ecs_task_role_arn

private_subnets = module.vpc.private_subnet_ids
ecs_sg_id       = module.security_groups.ecs_sg_id

listener_prod_dependency = module.alb.listener_prod_dependency
listener_test_dependency = module.alb.listener_test_dependency

tg_blue_arn   = module.alb.tg_blue_arn
desired_count = var.desired_count

db_host     = module.rds.rds_endpoint
db_name     = var.db_name
db_username = var.db_username
db_password = var.db_password
}

##########################################

# MODULE: CODEDEPLOY (ECS Blue/Green)

##########################################

module "codedeploy" {
  source = "./modules/codedeploy"

  name = var.project_name

  codedeploy_role_arn = var.codedeploy_role_arn
  ecs_cluster_name    = module.ecs.cluster_name
  ecs_service_name    = module.ecs.service_name

  listener_prod_arn = module.alb.listener_prod_arn   # corrected
  listener_test_arn = module.alb.listener_test_arn   # corrected

  tg_blue_name  = module.alb.tg_blue_name
  tg_green_name = module.alb.tg_green_name
}
