module "sg_egress" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v3.2.0"

  name        = "sg_egress"
  description = "egress all security group"
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "udp"
      from_port   = 0
      to_port     = 65535
      description = "egress all udp"
    },
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "tcp"
      from_port   = 0
      to_port     = 65535
      description = "egress all tcp"
    }
  ]

  tags = {
    Name = "egress_all"
  }
}