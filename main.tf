terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-west-1"
  access_key = ""
  secret_key = ""
}


resource "aws_instance" "example" {
  ami = "ami-014d05e6b24240371"
  count = 1
  instance_type = "t2.medium"
  key_name = "Project2"
  tags = {
    Name = "kub-s"
  }
}
resource "aws_instance" "main" {
  ami = "ami-014d05e6b24240371"
  count = 1
  instance_type = "t2.medium"
  key_name = "Project2"
  tags = {
     Name = "kub1-master"
  }
}
