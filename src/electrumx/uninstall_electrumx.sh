function uninstall_electrumx {
while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Electrum X
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done

set_terminal 

electrumx_tor_remove uninstall

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrumx.service >/dev/null 2>&1
sudo systemctl disable electrumx.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrumx.service >/dev/null 2>&1
fi

sudo rm -rf $hp/electrumx
pip3 uninstall electrumx || log electrumx "pip3 uninstall electrumx fail"
sudo rm -rf $HOME/.local/bin/electrumx* >/dev/null 2>&1
parmanode_conf_remove "drive_electrumx"
installed_conf_remove "electrumx-"
success "Electrum X" "being uninstalled"
}