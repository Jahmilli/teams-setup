resource "aws_lb" "teams" {
  name               = "${terraform.workspace}_teams"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.teams_loadbalancer.id]
  subnets            = [var.subnet_a, var.subnet_b]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.teams.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.teams.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "tomcat" {
  load_balancer_arn = aws_lb.teams.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.teams.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "teams" {
  name        = "${terraform.workspace}_teams"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 30
    interval            = 40
    path                = "/teams/actuator/health"
    protocol            = "HTTP"
  }
}
