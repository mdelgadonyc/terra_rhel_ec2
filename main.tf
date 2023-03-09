# Provider
 provider "aws" {
 }

# Retrieve the AZ where we want to create network resources
data "aws_availability_zones" "available" {}

# VPC Resource
resource "aws_vpc" "testvpc" {
  cidr_block = "10.11.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "Test-VPC"
    Environment = "Test"
  }
}

# AWS subnet resource
resource "aws_subnet" "testsub" {
 vpc_id = "${aws_vpc.testvpc.id}"
 cidr_block = "10.11.1.0/24"
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
 map_public_ip_on_launch = "false"
 tags = {
   Name = "Test_subnet1"
 }
}

# Create EC2 Test instance
resource "aws_instance" "testec2" {
  key_name = "rhcsakey"
  subnet_id = "${aws_subnet.testsub.id}"
  ami = "ami-0c41531b8d18cc72b"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  disable_api_termination = "false"
  monitoring = "false"
  vpc_security_group_ids = ["${aws_security_group.testsg.id}"]
  tags = {
    Name = "test-instance"
  }
}

# Create Test SG
resource "aws_security_group" "testsg" {
    vpc_id = "${aws_vpc.testvpc.id}"
    name = "testsg"
    description = "Test Security group"
    tags = {
        Name = "test-sg"
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.source_ip]
    }
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      from_port = -1
      to_port = -1
      protocol = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
}
