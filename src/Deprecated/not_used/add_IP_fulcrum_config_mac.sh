function add_IP_fulcrum_config {
sudo gsed -i "/bitcoind/d" $fc
echo "bitcoind = $IP:8332" | tee -a $fc >$dn 2>&1
}
