function uninstall_electrumx {
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Electrum X?
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

nginx_electrumx remove

electrumx_tor_remove uninstall

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrs.service >/dev/null 2>&1
sudo systemctl disable electrs.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrs.service >/dev/null 2>&1
fi

sudo rm -rf $hp/electrumx
pip3 uninstall electrumx
parmanode_conf_remove "drive_electrumx"
installed_conf_remove "electrumx-"
success "Electrum X" "being uninstalled"
}