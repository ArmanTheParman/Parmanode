function install_nym {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if echo $chip | grep -qE 'arm|aarch' ; then export forpi="true" ; fi 

unset swwflag
mkdir $hp/nym
installed_config_add "nym-start"
cd $hp/nym
curl -LO https://apt.nymtech.net/pool/main/n/nym-repo-setup/nym-repo-setup_1.0.1_amd64.deb 
sudo dpkg -i $hp/nym/nym-repo-setup_1.0.1_amd64.deb || sww
sudo apt install nym-vpn -y || sww

if [[ $swwflag == "true" ]] ; then unset swwflag ; return 1 ; fi
installed_config_add "nym-end"
installed_config_remove "nym-start"
success "Nym VPN installed"
}