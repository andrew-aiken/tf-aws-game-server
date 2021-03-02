output "mc_server_ec2" {
  value = module.mc_server_ec2.public_ip[0]
}