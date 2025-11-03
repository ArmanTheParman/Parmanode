function edit_bitcoindIP_fulcrum_indocker {   

# any updates here will not be reflected in the user's container if they update the hose
# computers' parmanode version, without rebuilding the docker container.

IP="$1"
sudo gsed -i "/bitcoind/d" $fc
echo "bitcoind = $IP:8332" >> $fc
}