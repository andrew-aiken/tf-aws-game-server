variable "aws_region" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type        = string
  description = "id of the vpc for the security group"
}