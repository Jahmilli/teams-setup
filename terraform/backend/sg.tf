resource "aws_security_group" "teams_loadbalancer" {
  name        = "${terraform.workspace}_teams_loadbalancer"
  description = "Provide all the required rules to access loadbalancers"
  vpc_id      = data.aws_vpc.id.id
}

resource "aws_security_group" "teams_container" {
  name        = "${terraform.workspace}_teams_container"
  description = "Provide all the required rules to access containers in ECS"
  vpc_id      = data.aws_vpc.id.id
}
