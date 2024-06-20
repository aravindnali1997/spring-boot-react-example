provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-west-2"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_instance" "backend" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  user_data     = <<-EOF
                #!/bin/bash
                docker run -d -p 8080:8080 ${DOCKER_IMAGE_BACKEND}
                EOF
}

resource "aws_instance" "frontend" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  user_data     = <<-EOF
                #!/bin/bash
                docker run -d -p 80:80 ${DOCKER_IMAGE_FRONTEND}
                EOF
}
