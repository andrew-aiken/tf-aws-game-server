output "public_ip" {
  description = "Public ip address"
  value = module.ec2_cluster.public_ip
}