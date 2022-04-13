output "tf2_game_server_ec2" {
  value = "connect ${module.game_server_ec2.public_ip}; password KRZC436EQC82XCWHC28E"
}
