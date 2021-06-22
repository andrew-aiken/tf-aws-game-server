variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile" {
  type    = string
  default = ""
}


### Input ###

variable "tf2MC" {
  type  = string
  description = "tf2? (default mc) y / N"
}

variable "serverType" {
  type        = string
  description = "Forge? (default paper) --- N / y"
}


### VPC ###
variable "vpc_name" {
  type    = string
  default = "vpc-mc"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type    = list(string)
  default = ["us-east-1a"]
}

variable "vpc_public_subnet" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}


### EC2 server ###
variable "vpn_ami" {
	type    = string
	default = "ami-03d315ad33b9d49c4"
}

variable "vpn_size" {
	type    = string
	default = "t2.large"
}

variable "ec2_ssh_key" {
	type        = string
	default     = "ec2_ssh_key"
	description = "SSH key name stored in ec2 keypairs"
}
