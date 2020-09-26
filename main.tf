# Authentication
provider "aws" {
  region     = "eu-west-2"
  shared_credentials_file = "/root/.aws/credentials"
  }
data "aws_availability_zones" "available" {}

