module "sg_voice" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v3.2.0"

  name        = "sg_voice"
  description = " security group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      from_port   = 24454
      to_port     = 24454
      protocol    = "udp"
      description = "ingress 24454 udp"
    }
  ]
  egress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "udp"
      from_port   = 24454
      to_port     = 24454
      description = "egress 24454 udp"
    }
  ]

  tags = {
    Name = "voice mc server"
  }
}