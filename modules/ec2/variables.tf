variable "name" {
  type        = string
  description = "Name of ec2 instance"
  default     = ""
}

variable "instance_count" {
  type        = string
  description = "Number of instances"
}

variable "ami" {
  type        = string
  description = "ami your variable"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security groups for ec2"
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "subnet of ec2"
}

variable "ec2_size" {
  type        = string
  description = "size of ec2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Key for ec2 to use"
  default     = ""
}

variable "private_ip" {
  type        = string
  description = "Private ip address of ec2 instance"
  default     = ""
}

variable "user_data" {
  type        = string
  description = "User data to pass into instance"
  default     = ""
}

variable "root_block_size" {
  type        = string
  description = "root_block_size"
  default     = 30
}