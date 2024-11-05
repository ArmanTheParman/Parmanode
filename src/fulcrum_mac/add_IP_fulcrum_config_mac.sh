function add_IP_fulcrum_config_mac {
sudo gsed -i "/bitcoind/d" $fc
echo "bitcoind = $IP:8332" >> $HOME/parmanode/fulcrum/fulcrum.conf 
}
