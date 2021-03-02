### Egress ###
output "sg_egress_id" {
  description = "The ID of sg_egress"
  value       = module.sg_egress.this_security_group_id
}

output "sg_egress_group_vpc_id" {
  description = "The VPC ID"
  value       = module.sg_egress.this_security_group_vpc_id
}

output "sg_egress_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_egress.this_security_group_owner_id
}

output "sg_egress_group_name" {
  description = "The name of the security group"
  value       = module.sg_egress.this_security_group_name
}

output "sg_egress_group_description" {
  description = "The description of the security group"
  value       = module.sg_egress.this_security_group_description
}

### mc ###
output "sg_mc_id" {
  description = "The ID of sg_mc"
  value       = module.sg_mc.this_security_group_id
}

output "sg_mc_group_vpc_id" {
  description = "The VPC ID"
  value       = module.sg_mc.this_security_group_vpc_id
}

output "sg_mc_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_mc.this_security_group_owner_id
}

output "sg_mc_group_name" {
  description = "The name of the security group"
  value       = module.sg_mc.this_security_group_name
}

output "sg_mc_group_description" {
  description = "The description of the security group"
  value       = module.sg_mc.this_security_group_description
}


### SSH ###
output "sg_ssh_22_id" {
  description = "The ID of sg_ssh_22"
  value       = module.sg_ssh_22.this_security_group_id
}

output "sg_ssh_22_group_vpc_id" {
  description = "The VPC ID"
  value       = module.sg_ssh_22.this_security_group_vpc_id
}

output "sg_ssh_22_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_ssh_22.this_security_group_owner_id
}

output "sg_ssh_22_group_name" {
  description = "The name of the security group"
  value       = module.sg_ssh_22.this_security_group_name
}

output "sg_ssh_22_group_description" {
  description = "The description of the security group"
  value       = module.sg_ssh_22.this_security_group_description
}
