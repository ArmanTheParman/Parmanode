function install_nym {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $computer_type = "Pi" ]] ; then announce "Not available for Pi yet, sorry." ; return 1 ; fi

mkdir $hp/nym
installed_config_add "nym-start"
cd $hp/nym || { sww ; return 1 ; }
download_nym || { sww ; return 1 ; }
sudo chmod +x $hp/nym/*AppImage 2>$dn

installed_config_add "nym-end"
installed_config_remove "nym-start"

if ! [[ $* =~ silent ]] ; then success "Nym VPN installed" ; fi
}
