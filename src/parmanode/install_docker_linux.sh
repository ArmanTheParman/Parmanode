function install_docker_linux {

while true ; do
set_terminal ; echo "
########################################################################################

                                Install Docker
    
    Parmanode will now install Docker on your system. You may wish to do this
    yourself, eg if the automatic install failed. If this is the case, just skip this
    automated installation to keep going with the set up.

                           i)      Install Docker

                           s)      Skip Docker Installation

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P|s|P) return 1 ;; 
i|I|install|Install)
    break ;;
*) invalid ;;
esac 
done

########################################################################################

while true ; do
set_terminal ; echo "
########################################################################################
    
                                  Pushing on...

    Docker manuals recommend running an UNINSTALL command in case there are older
    versions on the system which might cause conflicts. Shall Parmanode do that for
    you now?

                 y)     Yes, please, I'll have 2 of those thanks, doc
                 
                 n)     Nah, skip it, I'll risk it

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; 
y|Y|YES|yes|Yes) 
    sudo apt-get remove docker docker-engine docker.io containerd runc ;;
n|N|NO|No) break ;;
*) invalid
esac
done

debian_or_ubuntu #exits if neither
# download_docker_linux

}
########################################################################################
function debian_or_ubuntu {

if [ -f /etc/debian_version ]; then
parmanode_conf_add "Linux=Debian"
elif [ -f /etc/lsb-release ]; then
parmanode_conf_add "Linux=Ubuntu"
else
parmanod_conf_add "Linux=Unknown"
unable_install_docker_linux && return 1
fi
}

########################################################################################
function unable_install_docker_linux {
set_terminal_wider ; echo "
###########################################################################################################

    Parmanode was unable to match your OS to an available Docker installation. Please manually install 
    Docker yourself, then come back to Parmanode. Next time, choose to skip the Docker installation and 
    proceed. 

    You can try running this command:

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    ... although it is likely to not work. You would need to update your source list file. Instructions
    are here:

                https://docs.docker.com/engine/install/ubuntu/#install-from-a-package

###########################################################################################################
"
enter_continue ; return 1 
}

########################################################################################
function download_docker_linux {

chip="$(uname -m)" >/dev/null 2>&1
parmanode_conf_add "chip=$chip"

if [[ $chip == "x86_64" ]] ; then chip="amd64" ; fi
if [[ $chip == "aarch64" ]] ; then chip="arm64" ; fi
if [[ $chip == "armv7l" ]] ; then chip="armhf" ; fi

get_linux_version_codename

if [[ $VC = "bionic" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.18.04~$VC_$chip.deb
elif [[ $VC = "focal" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.20.04~$VC_$chip.deb
elif [[ $VC = "jammy" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.22.04~$VC_$chip.deb
elif [[ $VC = "kinetic" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.22.10~$VC_$chip.deb
elif [[ $VC = "lunar" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.23.04~$VC_$chip.deb
elif [[ $VC = "bookworm" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~debian.12~$VC_$chip.deb
elif [[ $VC = "bullseye" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.6.0~debian-$VC_$chip.deb
elif [[ $VC = "buster" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.6.0~debian-$VC_$chip.deb
else

fi
unset chip
}

########################################################################################

function docker_auto_install {


sudo apt-get update -y
sudo apt-get install ca-certificates curl gnupg -y

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update -y

get_linux_version_codename && echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(echo "$VCequivalent")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}