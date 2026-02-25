#codedeploy_role_arn = "arn:aws:iam::811738710312:role/codedeploy_role"

# -----------------------------
# PROJECT
# -----------------------------
project_name = "ecs-bluegreen"

# -----------------------------
# RDS
# -----------------------------
db_name     = "mydb"
db_username = "ecsuser"
db_password = "Admin1234!"

# -----------------------------
# ECS
# -----------------------------
desired_count     = 2
ecs_task_role_arn = "arn:aws:iam::811738710312:role/ecsTaskExecutionRole"

# -----------------------------
# CODEDEPLOY
# -----------------------------
codedeploy_role_arn = "arn:aws:iam::811738710312:role/codedeploy_role"