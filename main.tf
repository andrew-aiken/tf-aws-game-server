locals {
  forgeVersion    = "https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.16.5-36.0.43/forge-1.16.5-36.0.43-installer.jar"
  serverSideMods  = [
    "https://media.forgecdn.net/files/3075/425/Ma-Enchants-1.16.3-3.5.0.jar",
    "https://media.forgecdn.net/files/3222/129/Waystones_1.16.5-7.4.0.jar",
    "https://media.forgecdn.net/files/3237/944/voicechat-1.16.5-1.0.16.jar"
    // https://www.curseforge.com/minecraft/mc-mods/ma-enchants
    // https://www.curseforge.com/minecraft/mc-mods/waystones
    // https://www.curseforge.com/minecraft/mc-mods/simple-voice-chat
  ]
  hostSideMods    = [
    "https://media.forgecdn.net/files/3192/904/jei-1.16.4-7.6.1.71.jar"
    // https://optifine.net/downloads
    // https://www.curseforge.com/minecraft/mc-mods/jei
  ]
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_public_subnet  = var.vpc_public_subnet
  vpc_azs            = var.vpc_azs
  cidr               = var.cidr
  vpc_name           = var.vpc_name
}

module "sg_default" {
  source = "./modules/security_group/default"
  vpc_id = module.vpc.vpc_id
}

module "sg_mc" {
  source = "./modules/security_group/mc"
  vpc_id = module.vpc.vpc_id
}

module "sg_tf2" {
  source = "./modules/security_group/tf2"
  vpc_id = module.vpc.vpc_id
}

## connect 54.224.216.155; password KRZC436EQC82XCWHC28E

module "game_server_ec2" {
  source             = "./modules/ec2"
  instance_count     = "1"
  name               = var.tf2MC == "y" ? "TF2_Server" : (var.serverType == "y" ? "Force_MC_Server" : "Paper_MC_Server")
  ami                = var.vpn_ami
  security_group_ids = var.tf2MC == "y" ? [module.sg_default.sg_ssh_22_id,module.sg_tf2.sg_tf2_id] : [module.sg_default.sg_ssh_22_id,module.sg_mc.sg_mc_id,module.sg_mc.sg_voice_id]
  subnet_id          = module.vpc.public_subnets[0]
  ec2_size           = var.vpn_size
  key_name           = var.ec2_ssh_key
  root_block_size    = 30
  user_data          = var.tf2MC == "y" ? local.tf2_server_data : (var.serverType == "y" ? local.forge_user_data : local.paper_user_data)
}

locals {
 	tf2_server_data = <<-EOF
	#!/bin/bash
	mkdir /hlserver
	chmod 775 /hlserver
	chown ubuntu /hlserver
	cd /hlserver
	dpkg --add-architecture i386
	apt-get update
	apt-get install lib32z1 libncurses5:i386 libbz2-1.0:i386 lib32gcc-s1 lib32stdc++6 libtinfo5:i386 libcurl3-gnutls:i386 -y
	apt install libsdl2-2.0-0:i386 -y
	wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
	tar zxf steamcmd_linux.tar.gz
	echo "login anonymous
	force_install_dir /hlserver/tf2
	app_update 232250
	quit" > tf2_ds.txt
	echo "./steamcmd.sh +runscript tf2_ds.txt" > update.sh
	chmod +x steamcmd.sh
	chmod +x update.sh
	chown ubuntu *
	sudo sh /hlserver/update.sh
	echo "/hlserver/tf2/srcds_run -console -game tf -timeout 0 -autoupdate -steam_dir /hlserver -steamcmd_script /hlserver/tf2_ds.txt +maxplayers 24 +map ctf_2fort +sv_pure 0" > tf.sh
	chown ubuntu /hlserver/tf.sh
	chmod +x tf.sh
	echo """${file("configs/tf2/server.cfg")}""" > /hlserver/tf2/tf/cfg/server.cfg
	cd /hlserver/tf2/tf
	wget https://mms.alliedmods.net/mmsdrop/1.11/mmsource-1.11.0-git1144-linux.tar.gz
	tar zxf mmsource-1.11.0-git1144-linux.tar.gz
	wget https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz
	tar zxf sourcemod-1.10.0-git6502-linux.tar.gz
	echo '"STEAM_0:1:201138974"        "99:z"' >> /hlserver/tf2/tf/addons/sourcemod/configs/admins_simple.ini
	sudo -u ubuntu bash /hlserver/tf.sh
  EOF
  paper_user_data = <<-EOF
    #! /bin/bash
    apt-get install -y wget apt-transport-https gnupg
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2) main" | tee /etc/apt/sources.list.d/adoptopenjdk.list
    apt-get update
    apt-get install adoptopenjdk-16-hotspot -y
    apt-get install jq -y
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
    mkdir /paper
    cd /paper
    LATEST_BUILD=$(curl -X GET "https://papermc.io/api/v2/projects/paper/versions/1.17" -H  "accept: application/json" | jq '.builds[-1]')
    curl -o paperclip.jar -X GET "https://papermc.io/api/v2/projects/paper/versions/1.17/builds/$${LATEST_BUILD}/downloads/paper-1.17-$${LATEST_BUILD}.jar" -H  "accept: application/java-archive" -JO
    curl -X GET "https://papermc.io/api/v2/projects/paper/versions/1.17" -H  "accept: application/json"
    curl -o paperclip.jar -X GET "https://papermc.io/api/v2/projects/paper/versions/1.17/builds/[BUILD_ID]/downloads/paper-1.17-[BUILD_ID].jar" -H  "accept: application/java-archive" -JO
    java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui
    echo "eula=true" > eula.txt
    echo "java -Xms4G -Xmx4G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar paperclip.jar nogui" > start.sh
    chmod 750 start.sh
    echo "[
        {
          "uuid": "8fe5fa2d-100c-4332-891f-97520ea37888",
          "name": "i8MadChicken",
          "level": 4,
          "bypassesPlayerLimit": false
        }
      ] "> /paper/ops.json
    git clone https://github.com/Mad-Chicken/DeathswapPlus.git /paper/world/datapacks/deathswap
    ./start.sh
  EOF
  forge_user_data = <<-EOF
    #! /bin/bash
    apt-get install -y wget apt-transport-https gnupg
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2) main" | tee /etc/apt/sources.list.d/adoptopenjdk.list
    apt-get update
    apt-get install adoptopenjdk-11-hotspot -y
    apt-get install jq -y
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
    mkdir /forge
    cd /forge
    curl -o forge.jar -X GET "${local.forgeVersion}" -H  "accept: application/java-archive" -JO
    java -jar forge.jar --installServer
    java -Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar forge-1.16.5-36.0.43.jar nogui
    echo "eula=true" > eula.txt
    echo "java -Xms8G -Xmx8G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar forge-1.16.5-36.0.43.jar nogui" > start.sh
    chmod 750 start.sh
    cd /forge/mods
    curl -o "enchant.jar" -X GET "${local.serverSideMods[0]}" -H  "accept: application/java-archive" -JO
    curl -o "waystone.jar" -X GET "${local.serverSideMods[1]}" -H  "accept: application/java-archive" -JO
    curl -o "voice.jar" -X GET "${local.serverSideMods[2]}" -H  "accept: application/java-archive" -JO
    cd /forge
    ./start.sh
  EOF
}
