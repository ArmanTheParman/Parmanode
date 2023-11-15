function uninstall_btcrpcexplorer {
    
set_terminal ; echo "
########################################################################################

                                 Uninstall BTC RPC Explorer

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

rm -rf $HOME/parmanode/btc-rpc*

sudo systemctl stop btcrpcexplorer.service >/dev/null
sudo systemctl disable btcrpcexplorer.service >/dev/null
sudo rm /etc/systemd/system/btcrpcexplorer.service >/dev/null
sudo rm /etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null
sudo rm /usr/local/etc/nginx/conf.d/btcrpcexplorer.conf 2>/dev/null
installed_conf_remove "btcrpcexplorer"

success "BTC RPC Explorer" "being uinstalled."

}