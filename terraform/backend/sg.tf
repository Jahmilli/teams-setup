resource "aws_security_group" "teams" {
  name        = "${terraform.workspace}_teams"
  description = "Provide all the required rules to access and use the application"
  vpc_id      = data.aws_vpc.id.id
}
