function uninstall_core_lightning {

while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall electrs 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

sudo rm -rf $hp/core_lightning
sudo rm /usr/bin/lightning-cli  /usr/bin/lightningd  /usr/bin/lightning-hsmtool  /usr/bin/reckless >$dn
sudo rm /usr/local/bin/lightning-cli  /usr/local/bin/lightningd  /usr/local/bin/lightning-hsmtool  /usr/local/bin/reckless >$dn
yesorno "Would you like to remove the Core Lightning data directory at:
$cyan
    $HOME/.lightning? 
$orange 
    This will delete your channels and funds if you haven't closed them." && sudo rm -rf $HOME/.lightning

sudo systemctl stop core-lightning.service >$dn 2>&1
sudo systemctl disable core-lightning.service >$dn 2>&1
sudo rm /etc/systemd/system/core-lightning.service >$dn 2>&1
sudo rm $HOME/.lightning >$dn 2>&1

installed_conf_remove "cln-"
success "Core Lightning Uninstalled"
}
