# Specifie the configuration for Terraform, and declare the required AWS provider and version

terraform {
  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# Declare the provider for AWS and set the region

provider "aws" {
         region = "eu-central-1"
 }

# Declare a data source that retrieves the most recent Amazon Machine Image (AMI) 

data "aws_ami" "ubuntu" {
   most_recent = true
 
   filter {
     name = "name"
     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
   }
 
   filter {
     name = "virtualization-type"
     values = ["hvm"]
   }
 
   owners = ["099720109477"] # Canonical
 }

# Declare a security group resource for the VPC, allow incomming traffic on ports and outgoing traffic

resource "aws_security_group" "security_terraform" {
   name = "security_terraform"
   vpc_id = 
   description = "security group for terraform"
 
   ingress {
     from_port = 80
     to_port = 80
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   
   ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 
   egress {
     from_port = 0
     to_port = 65535
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
 
   tags = {
     Name = "security_terraform"
   }
 }

# Finally create an EC2 instance

resource "aws_instance" "wordpress" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = t2.micro
  subnet_id              = 
  vpc_security_group_ids = ["security_terraform"]
  key_name               = 
  tags = {
    Name = "wordpress"
  }
}
