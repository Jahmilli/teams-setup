resource "aws_security_group_rule" "app_ingress_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams.id
}

resource "aws_security_group_rule" "app_egress_http" {
  type      = "egress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams.id
}

resource "aws_security_group_rule" "app_ingress_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams.id
}

resource "aws_security_group_rule" "app_egress_https" {
  type      = "egress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams.id
}

resource "aws_security_group_rule" "app_ingress_tomcat" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams.id
}
