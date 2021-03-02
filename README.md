## What is?
Minecraft server running on a headless aws ec2 server.<br>
The paper install come with DeathSwapPlus datapack pre installed!<br>
https://github.com/Mad-Chicken/DeathswapPlus


## Prerequisites
Terraform v0.14.5<br>
AWS CLI installed


## Running
Switch out mod/forge to desired version. Change ec2 server / disk size<br>
```terraform init```<br>
```terraform apply```<br>
Select if you want paper or forge server<br>
Type 'yes' to run script<br><br>
To shutdown run ```terraform  destroy``` and follow the above steps.


## Help from
https://www.linuxnorth.org/minecraft/modded_linux_condensed.html
