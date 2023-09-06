function uninstall_btcrpcexplorer {

rm -rf $HOME/parmanode/btc-rpc*

sudo systemctl stop btcrpcexplorer.service >/dev/null
sudo systemctl disable btcrpcexplorer.service >/dev/null
sudo rm /etc/systemd/system/btcrpcexplorer.service >/dev/null

installed_conf_remove "btcrpcexplorer"

success "BTC RPC Explorer" "being uinstalled."

}