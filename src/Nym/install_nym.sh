function install_nym {

mkdir $hp/nym
installed_config_add "nym-start"
cd $hp/nym
curl -LO https://apt.nymtech.net/pool/main/n/nym-repo-setup/nym-repo-setup_1.0.1_amd64.deb 
sudo dpkg -i /tmp/nym-repo-setup_1.0.1_amd64.deb || sww
sudo apt install nym-vpn || sww
installed_config_add "nym-end"
installed_config_remove "nym-start"
success "Nym VPN installed"
}