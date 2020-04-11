terraform {
  backend "s3" {
    bucket = "sebs-terraform-state"
    key    = "teams"
    region = "ap-southeast-2"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}
