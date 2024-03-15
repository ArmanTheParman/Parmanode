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
clear

while true ; do
if [[ $choice == "y" || $choice == "Y" ]] ; then 
   debug "0.0"
   break 
else 
   debug "0.5"
   return 1
fi
done

debug "1"
#leave here for old installations. Electrum x new installs don't use nginx
nginx_stream electrumx remove
debug "2"

electrumx_tor_remove uninstall || log electrumx "electrumx_tor_remove return 1"
debug "3"

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrumx.service >/dev/null 2>&1
sudo systemctl disable electrumx.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrumx.service >/dev/null 2>&1
fi
debug "4"

sudo rm -rf $hp/electrumx
pip3 uninstall electrumx || log electrumx "pip3 uninstall electrumx fail"
if [[ $test == 1 ]] ; then echo 5 ; enter_continue ; fi
debug "5"
sudo rm -rf $HOME/.local/bin/electrumx* >/dev/null 2>&1
parmanode_conf_remove "drive_electrumx"
installed_conf_remove "electrumx-"
if [[ $test == 1 ]] ; then echo 6 ; fi
success "Electrum X" "being uninstalled"
}