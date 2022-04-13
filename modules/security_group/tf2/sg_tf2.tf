module "sg_tf2" {
  //source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=tags/v4.0.0"
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "sg_tf2"
  description = "TF2 security group"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      from_port   = 27005
      to_port     = 27020
      protocol    = "tcp"
      description = "ingress 27005-27020 tcp"
    },
    {
      cidr_block  = "0.0.0.0/0"
      from_port   = 27005
      to_port     = 27020
      protocol    = "udp"
      description = "ingress 27005-27020 udp"
    }
  ]
  egress_with_cidr_blocks = [
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "tcp"
      from_port   = 27005
      to_port     = 27020
      description = "egress 27005-27020 tcp"
    },
    {
      cidr_block  = "0.0.0.0/0"
      protocol    = "udp"
      from_port   = 27005
      to_port     = 27020
      description = "egress 27005-27020 udp"
    }
  ]

  tags = {
    Name = "tf2 server"
  }
}