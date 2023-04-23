function edit_bitcoindIP_fulcrum_indocker {   

# any updates here will not be reflected in the user's container if they update the hose
# computers' parmanode version, without rebuilding the docker container.

IP=$1


delete_line "$HOME/parmanode/fulcrum/fulcrum.conf" "bitcoind"

echo "bitcoind = $IP:8332" >> $HOME/parmanode/fulcrum/fulcrum.conf

return 0
}