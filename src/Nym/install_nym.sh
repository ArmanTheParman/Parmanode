function install_nym {
unset swwflag
mkdir $hp/nym
installed_config_add "nym-start"
cd $hp/nym
curl -LO https://apt.nymtech.net/pool/main/n/nym-repo-setup/nym-repo-setup_1.0.1_amd64.deb 
sudo dpkg -i $hp/nym-repo-setup_1.0.1_amd64.deb || sww
sudo apt install nym-vpn || sww
installed_config_add "nym-end"
installed_config_remove "nym-start"

if [[ $swwflag == "true" ]] ; then unset swwflag ; return 1 ; fi
success "Nym VPN installed"
}

function uninstall_nym {
stop_nym 2>$dn
sudo apt remove --purge nym-vpn
rm -rf $hp/nym
installed_config_remove "nym-"
}