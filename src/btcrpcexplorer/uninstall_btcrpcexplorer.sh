function uninstall_btcrpcexplorer {

rm -rf $HOME/parmanode/btc-rpc*

installed_conf_remove "btcrpcexplorer"

success "BTC RPC Explorer" "being uinstalled."

}