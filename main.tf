# Authentication
provider "aws" {
  region     = "eu-west-2"
  access_key = ""
  secret_key = ""
}
data "aws_availability_zones" "available" {}

