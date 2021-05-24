module "sg_ssh_22" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//modules/ssh?ref=tags/v4.0.0"

  name        = "sg_ssh_22"
  description = "Security group for ssh with ports 22 open"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  tags = {
    Name = "ssh"
  }
}