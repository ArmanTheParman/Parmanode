#Not used, for reference only for now:
function manual_download_docker_linux {

if [[ $chip == "x86_64" ]] ; then chip="amd64" ; fi
if [[ $chip == "aarch64" ]] ; then chip="arm64" ; fi
if [[ $chip == "armv7l" ]] ; then chip="armhf" ; fi

get_linux_version_codename

if [ ! -z $VCequivalent ] ; then VC=$VCequivalent ; fi

if [[ $VC == "bionic" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.18.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.18.04~$VC_$chip.deb
elif [[ $VC == "focal" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.20.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.20.04~$VC_$chip.deb
elif [[ $VC == "jammy" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.22.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.22.04~$VC_$chip.deb
elif [[ $VC == "kinetic" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.22.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.22.10~$VC_$chip.deb
elif [[ $VC == "lunar" ]] ; then
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~ubuntu.23.04~$VC_$chip.deb
curl -LO https://download.docker.com/linux/ubuntu/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~ubuntu.23.04~$VC_$chip.deb
elif [[ $VC == "bookworm" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.20-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.12~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.17.2-1~debian.12~$VC_$chip.deb
elif [[ $VC == "bullseye" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.6.0~debian-$VC_$chip.deb
elif [[ $VC == "buster" ]] ; then
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/containerd.io_1.6.9-1_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce_23.0.4-1~debian.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-ce-cli_23.0.4-1~debian.10~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-buildx-plugin_0.10.4-1~debian.11~$VC_$chip.deb
curl -LO https://download.docker.com/linux/debian/dists/$VC/pool/stable/$chip/docker-compose-plugin_2.6.0~debian-$VC_$chip.deb
fi
unset chip
}