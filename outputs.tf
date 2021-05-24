output "game_server_ec2" {
  value = "connect ${module.game_server_ec2.public_ip[0]}; password KRZC436EQC82XCWHC28E"
}

# tf_weapon_criticals 0, tf_weapon_criticals_melee 0