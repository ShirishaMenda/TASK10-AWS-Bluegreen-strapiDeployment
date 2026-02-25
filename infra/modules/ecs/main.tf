# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = "${var.name}-cluster"

  tags = {
    Name = "${var.name}-cluster"
  }
}

# ----------------------------
# TASK DEFINITION
# ----------------------------

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.name}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory

   execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"
  task_role_arn      = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([
    {
      name       = "strapi"
      image      = "${var.ecr_repo_url}:latest"
      essential  = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DATABASE_CLIENT",  value = "postgres" },
        { name = "DATABASE_HOST",    value = var.db_host },
        { name = "HOST",             value = "0.0.0.0" },
        { name = "PORT",             value = "1337" },
        { name = "NODE_ENV",         value = "production" },
        { name = "DATABASE_PORT",    value = "5432" },
        { name = "DATABASE_NAME",    value = var.db_name },
        { name = "DATABASE_USERNAME",value = var.db_username },
        { name = "DATABASE_PASSWORD",value = var.db_password },
        { name = "DATABASE_SSL",     value = "true" },
        { name = "DATABASE_SSL_REJECT_UNAUTHORIZED", value = "false" },

        { name = "APP_KEYS",               value = "key1,key2,key3,key4" },
        { name = "API_TOKEN_SALT",         value = "yoursalt" },
        { name = "ADMIN_JWT_SECRET",       value = "youradminsecret" },
        { name = "JWT_SECRET",             value = "yourjwtsecret" }  
      ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
      "awslogs-group"         = "/ecs/ecs-bluegreen-logs"
      "awslogs-region"        = "us-east-1"
      "awslogs-stream-prefix" = "ecs"
      }
    }
    }
  ])
}

# ----------------------------
# ECS SERVICE (BLUE/GREEN)
# ----------------------------

resource "aws_ecs_service" "this" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  task_definition = aws_ecs_task_definition.this.arn

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  # ⚠️ REQUIRED FOR CODE_DEPLOY
  load_balancer {
    target_group_arn = var.tg_blue_arn
    container_name   = "strapi"
    container_port   = 1337
  }

  # ⚠️ REQUIRED OR DEPLOYMENT FAILS
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  health_check_grace_period_seconds = 120

  lifecycle {
    ignore_changes = [
      task_definition,
      desired_count,
      load_balancer
    ]
  }

  depends_on = [
  var.listener_prod_dependency,
  var.listener_test_dependency
  
]

  tags = {
    Name = "${var.name}-service"
  }
}

