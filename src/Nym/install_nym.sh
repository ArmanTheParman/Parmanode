function install_nym {

mkdir $hp/nym
cd $hp/nym
curl -LO https://apt.nymtech.net/pool/main/n/nym-repo-setup/nym-repo-setup_1.0.1_amd64.deb 

sudo dpkg -i /tmp/nym-repo-setup_1.0.1_amd64.deb

sudo apt install nym-vpn

}