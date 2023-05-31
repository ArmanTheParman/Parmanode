function add_IP_fulcrum_config_mac {

delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "bitcoind"

echo "bitcoind = $IP" >> $HOME/parmanode/fulcrum/fulcrum.conf 
}