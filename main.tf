locals {
  forgeVersion = "https://files.minecraftforge.net/maven/net/minecraftforge/forge/1.16.5-36.0.43/forge-1.16.5-36.0.43-installer.jar"
  forgeMod     = "https://media.forgecdn.net/files/3125/361/repurposed_structures-1.16.4-2.3.3.jar"
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

module "sg" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
}

module "mc_server_ec2" {
  source             = "./modules/ec2"
  instance_count     = "1"
  name               = var.serverType == "y" ? "Force_MC_Server" : "Paper_MC_Server"
  ami                = var.vpn_ami
  security_group_ids = [module.sg.sg_ssh_22_id,module.sg.sg_mc_id]
  subnet_id          = module.vpc.public_subnets[0]
  ec2_size           = var.vpn_size
  key_name           = var.ec2_ssh_key
  root_block_size    = 30
  user_data          = var.serverType == "y" ? local.forge_user_data : local.paper_user_data
}

locals {
  paper_user_data = <<-EOF
    #! /bin/bash
    sudo su -
    apt-get install -y wget apt-transport-https gnupg
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2) main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
    apt-get update
    apt-get install adoptopenjdk-11-hotspot -y
    apt-get install jq -y
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
    mkdir /paper
    cd /paper
    LATEST_BUILD=$(curl -X GET "https://papermc.io/api/v2/projects/paper/versions/1.16.5" -H  "accept: application/json" | jq '.builds[-1]')
    curl -o paperclip.jar -X GET "https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/$${LATEST_BUILD}/downloads/paper-1.16.5-$${LATEST_BUILD}.jar" -H  "accept: application/java-archive" -JO
    curl -X GET "https://papermc.io/api/v2/projects/paper/versions/1.16.5" -H  "accept: application/json"
    curl -o paperclip.jar -X GET "https://papermc.io/api/v2/projects/paper/versions/1.16.5/builds/[BUILD_ID]/downloads/paper-1.16.5-[BUILD_ID].jar" -H  "accept: application/java-archive" -JO
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
    sudo ./start.sh
  EOF
  forge_user_data = <<-EOF
    #! /bin/bash
    sudo su -
    apt-get install -y wget apt-transport-https gnupg
    wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
    echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb $(cat /etc/os-release | grep UBUNTU_CODENAME | cut -d = -f 2) main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
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
    curl -o repurposed_structures.jar -X GET "${local.forgeMod}" -H  "accept: application/java-archive" -JO
    cd /forge && ./start.sh
  EOF
}