function uninstall_btcrpcexplorer {
while true ; do 
set_terminal ; echo -e "
########################################################################################
$cyan
                             Uninstall BTC RPC Explorer
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;; y) break ;; n) return 1 ;; *) invalid ;;
esac
done
sudo rm -rf $HOME/parmanode/btc-rpc*

sudo systemctl stop btcrpcexplorer.service >$dn
sudo systemctl disable btcrpcexplorer.service >$dn
sudo rm /etc/systemd/system/btcrpcexplorer.service >$dn
sudo rm /etc/nginx/conf.d/btcrpcexplorer.conf 2>$dn
sudo rm /usr/local/etc/nginx/conf.d/btcrpcexplorer.conf 2>$dn
installed_conf_remove "btcrpcexplorer"

success "BTC RPC Explorer" "being uinstalled."

}