output "codedeploy_app" {
  value = aws_codedeploy_app.this.name
}

output "codedeploy_deployment_group" {
  value = aws_codedeploy_deployment_group.this.deployment_group_name
}