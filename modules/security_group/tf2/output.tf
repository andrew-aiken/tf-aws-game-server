### tf2 ###
output "sg_tf2_id" {
  description = "The ID of sg_tf2"
  value       = module.sg_tf2.security_group_id
}

output "sg_tf2_group_vpc_id" {
  description = "The VPC ID"
  value       = module.sg_tf2.security_group_vpc_id
}

output "sg_tf2_group_owner_id" {
  description = "The owner ID"
  value       = module.sg_tf2.security_group_owner_id
}

output "sg_tf2_group_name" {
  description = "The name of the security group"
  value       = module.sg_tf2.security_group_name
}

output "sg_tf2_group_description" {
  description = "The description of the security group"
  value       = module.sg_tf2.security_group_description
}
