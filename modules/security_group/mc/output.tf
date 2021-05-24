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


### voice ###
output "sg_voice_id" {
  description = "The ID of sg_mc"
  value       = module.sg_voice.this_security_group_id
}

output "sg_voice_group_vpc_id" {
  description = "The VPC ID"
  value       = module.sg_voice.this_security_group_vpc_id
}

output "sg_voice_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_voice.this_security_group_owner_id
}

output "sg_voice_group_name" {
  description = "The name of the security group"
  value       = module.sg_voice.this_security_group_name
}

output "sg_voice_group_description" {
  description = "The description of the security group"
  value       = module.sg_voice.this_security_group_description
}
