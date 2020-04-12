resource "aws_ecs_cluster" "teams" {
  name = "${terraform.workspace}_teams"
}

resource "aws_ecs_task_definition" "teams_backend" {
  family                   = "${terraform.workspace}_teams-backend"
  execution_role_arn       = "arn:aws:iam::699129468547:role/ecsTaskExecutionRole"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = file("../../ecs/teams-backend.td.json")
}

resource "aws_ecs_service" "teams" {
  name            = "${terraform.workspace}_teams"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.teams_backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.teams_container.id]
    subnets          = [var.subnet_a, var.subnet_b]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.teams.id
    container_name   = "teams-backend"
    container_port   = 8080
  }

  depends_on = [aws_alb_listener.tomcat]
}
