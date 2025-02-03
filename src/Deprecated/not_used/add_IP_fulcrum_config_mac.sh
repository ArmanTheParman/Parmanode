function add_IP_fulcrum_config {
nogsedtest
sudo gsed -i "/bitcoind/d" $fc
echo "bitcoind = $IP:8332" | tee -a $fc >$dn 2>&1
}
