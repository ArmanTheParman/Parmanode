function uninstall_btcrpcexplorer {
    
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
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done
sudo rm -rf $HOME/parmanode/btc-rpc*

sudo systemctl stop btcrpcexplorer.service >/dev/null
sudo systemctl disable btcrpcexplorer.service >/dev/null
sudo rm /etc/systemd/system/btcrpcexplorer.service >/dev/null
sudo rm /etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null
sudo rm /usr/local/etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null
installed_conf_remove "btcrpcexplorer"

success "BTC RPC Explorer" "being uinstalled."

}