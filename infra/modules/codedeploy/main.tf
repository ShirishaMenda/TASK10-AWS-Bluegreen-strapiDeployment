resource "aws_codedeploy_app" "this" {
  name             = "${var.name}-codedeploy"
  compute_platform = "ECS"

  tags = {
    Name = "${var.name}-codedeploy"
  }
}

resource "aws_codedeploy_deployment_group" "this" {

  app_name               = aws_codedeploy_app.this.name
  deployment_group_name  = "${var.name}-dg"
  service_role_arn       = var.codedeploy_role_arn

  # Safer for testing first
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {

    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes  = 5
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = [
      "DEPLOYMENT_FAILURE",
      "DEPLOYMENT_STOP_ON_ALARM",
      "DEPLOYMENT_STOP_ON_REQUEST"
    ]
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  load_balancer_info {

    target_group_pair_info {

      # BLUE
      target_group {
        name = var.tg_blue_name
      }

      # GREEN
      target_group {
        name = var.tg_green_name
      }

      # Production Listener (Port 80)
      prod_traffic_route {
        listener_arns = [var.listener_prod_arn]
      }

      # Test Listener (Port 9000)
      test_traffic_route {
        listener_arns = [var.listener_test_arn]
      }
    }
  }

  depends_on = [
    aws_codedeploy_app.this
  ]
}