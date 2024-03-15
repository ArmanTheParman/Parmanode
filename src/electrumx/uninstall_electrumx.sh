function uninstall_electrumx {
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Electrum X
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

#leave here for old installations. Electrum x new installs don't use nginx
nginx_stream electrumx remove

electrumx_tor_remove uninstall || log electrumx "electrumx_tor_remove return 1"

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrumx.service >/dev/null 2>&1
sudo systemctl disable electrumx.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrumx.service >/dev/null 2>&1
fi

sudo rm -rf $hp/electrumx
pip3 uninstall electrumx || log electrumx "pip3 uninstall electrumx fail"
debug "/usr/local/bin/elecrumx* removed?"
sudo rm -rf $HOME/.local/bin/electrumx* >/dev/null 2>&1
parmanode_conf_remove "drive_electrumx"
installed_conf_remove "electrumx-"
success "Electrum X" "being uninstalled"
}