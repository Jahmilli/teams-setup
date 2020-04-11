resource "aws_lb" "alb" {
  name               = "teams"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.teams.id]
  subnets            = [var.subnet_a, var.subnet_b]
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb_listener_tomcat" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }
}

# resource "aws_alb_listener_rule" "http_listener_rule" {
#   depends_on   = ["aws_alb_target_group.alb_target_group"]
#   listener_arn = "${aws_alb_listener.alb_listener.arn}"
#   priority     = "${var.priority}"
#   action {
#     type             = "forward"
#     target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
#   }
#   # condition {
#   #   field  = "path-pattern"
#   #   values = ["${var.alb_path}"]
#   # }
# }

resource "aws_lb_target_group" "lb_target_group" {
  name        = "teams-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/teams/actuator/health"
    protocol            = "HTTP"
  }
}
