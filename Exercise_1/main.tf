# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "XXXXXXXX"
  secret_key = "XXXXXXXX"
  region = "us-east-1"
}

# Use an existing VPC and Subnet
variable "vpc_id" {}
variable "subnet_id" {}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  ami = "ami-05b10e08d247fb927"
  instance_type = "t2.micro"
  count = "4"
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  ami = "ami-05b10e08d247fb927"
  instance_type = "m4.large"
  count = "2"
}
