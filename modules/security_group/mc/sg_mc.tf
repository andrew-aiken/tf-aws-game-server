module "sg_mc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v3.2.0"

  name        = "sg_mc"
  description = "MC security group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      from_port   = 25565
      to_port     = 25565
      protocol    = "tcp"
      description = "ingress 25565 tcp"
    },
    {
      cidr_block  = "0.0.0.0/0"
      from_port   = 25565
      to_port     = 25565
      protocol    = "udp"
      description = "ingress 25565 udp"
    }
  ]
  egress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "tcp"
      from_port   = 25565
      to_port     = 25565
      description = "egress 25565 tcp"
    },
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "udp"
      from_port   = 25565
      to_port     = 25565
      description = "egress 25565 udp"
    }
  ]

  tags = {
    Name = "minecraft server"
  }
}