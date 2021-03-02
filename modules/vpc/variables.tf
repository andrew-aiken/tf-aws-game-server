variable "vpc_name" {
	type    = string
	default = ""
}

variable "cidr" {
	type = string
}

variable "vpc_azs" {
  type = list(string)
}

variable "vpc_public_subnet" {
	type = list(string)
}
