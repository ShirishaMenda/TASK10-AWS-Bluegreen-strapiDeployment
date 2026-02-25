resource "aws_lb" "alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "${var.name}-alb"
  }
}

# -------------------------
# BLUE Target Group
# -------------------------
resource "aws_lb_target_group" "blue" {
  name     = "${var.name}-tg-blue"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
  path                = "/admin"
  protocol            = "HTTP"
  port                = "traffic-port"   # ensures it hits the port defined in the target group
  interval            = 30
  timeout             = 10
  healthy_threshold   = 3
  unhealthy_threshold = 5
  matcher             = "200-399"
  }

  tags = {
    Name = "${var.name}-tg-blue"
  }
}

# -------------------------
# GREEN Target Group
# -------------------------
resource "aws_lb_target_group" "green" {
  name     = "${var.name}-tg-green"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  
  health_check {
  path                = "/admin"
  protocol            = "HTTP"
  port                = "traffic-port"   # ensures it hits the port defined in the target group
  interval            = 30
  timeout             = 10
  healthy_threshold   = 3
  unhealthy_threshold = 5
  matcher             = "200-399"
}

  tags = {
    Name = "${var.name}-tg-green"
  }
}

# -------------------------
# Listener (Production → BLUE)
# -------------------------
resource "aws_lb_listener" "listener_prod" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

# -------------------------
# Listener (Test → GREEN)
# -------------------------
resource "aws_lb_listener" "listener_test" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 9000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }
}