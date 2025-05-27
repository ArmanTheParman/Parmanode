function install_nym {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if echo $chip | grep -qE 'arm|aarch' ; then export forpi="true" ; fi 

unset swwflag
installed_config_add "nym-start"

if [[ $forpi == "true" ]] ; then
sudo apt-get install -y pkg-config build-essential libssl-dev
which cargo >$dn 2>&1 || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
git clone https://github.com/nymtech/nym.git $hp/nym
cd $hp/nym
git checkout v1.1.22
cross build --target aarch64-unknown-linux-gnu --release
else
mkdir $hp/nym
cd $hp/nym
curl -LO https://apt.nymtech.net/pool/main/n/nym-repo-setup/nym-repo-setup_1.0.1_amd64.deb 
sudo dpkg -i $hp/nym/nym-repo-setup_1.0.1_amd64.deb || sww
sudo apt install nym-vpn -y || sww
fi

if [[ $swwflag == "true" ]] ; then unset swwflag ; return 1 ; fi
installed_config_add "nym-end"
installed_config_remove "nym-start"
success "Nym VPN installed"
}

function install_nym_pi {

cargo install cross --git https://github.com/cross-rs/cross
cd nym
git checkout v1.1.22
}
