######################## Teams Loadbalancer Rules ########################
resource "aws_security_group_rule" "teams_loadbalancer_ingress_http" {
  type      = "ingress"
  from_port = 80
  to_port   = 80
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams_loadbalancer.id
}

# TODO: Adjust this to use source security group teams_container
resource "aws_security_group_rule" "teams_loadbalancer_egress_all" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams_loadbalancer.id
}

resource "aws_security_group_rule" "teams_loadbalancer_ingress_https" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams_loadbalancer.id
}

######################## Teams Container Rules ########################

# TODO: Adjust this to use source security group Loadbalancer
resource "aws_security_group_rule" "teams_container_ingress_all" {
  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams_container.id
}

# TODO: Adjust this to use source security group teams_loadbalancer (also possibly change from port to 32768)
resource "aws_security_group_rule" "teams_container_egress_all" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  cidr_blocks = ["0.0.0.0/0"] # Definitely fix this up

  security_group_id = aws_security_group.teams_container.id
}
