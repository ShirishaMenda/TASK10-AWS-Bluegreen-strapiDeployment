resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${var.name}-rds-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "${var.name}-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier              = "${var.name}-postgres"
  engine                  = "postgres"
  engine_version          = "15"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  vpc_security_group_ids  = [var.rds_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name

  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false

  backup_retention_period = 7

  tags = {
    Name = "${var.name}-rds"
  }
}