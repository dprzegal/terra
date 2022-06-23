variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "amis" {
  type = map(string)
  default = {
    eu-central-1 = "ami-0d06de6bae4839627" #Ami Ubuntu Jammy 22.04
    eu-west-1 = "ami-0c0aa81a5fab62093"
  }
}

variable "key_name" {
  default = "devops-terra-dpr-key"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_BH_name" {
  description = "Value of the Name tag for Bastion Host EC2 Instance"
  type = string
  default = "Bastion Host"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "192.168.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "eu-central-1a",  #"${var.AWS_REGION}a",
    "eu-central-1b",  #"${var.AWS_REGION}b",
    "eu-central-1c",  #"${var.AWS_REGION}c",
    ]
}

variable "private_subnets" {
  description = "Available cidr blocks for private subnets."
  type    = list(string)
  default = [
    "192.168.1.0/24",
    "192.168.2.0/24",
    "192.168.3.0/24",
    ]
}

variable "public_subnets" {
  description = "Available cidr blocks for public subnets."
  type = list(string)
  default = [
    "192.168.101.0/24",
    "192.168.102.0/24",
    "192.168.103.0/24",
    ]
}

variable "path_to_ansible_files" {
  type = string
  default = "" #"/home/ansible_docker_user/"
}