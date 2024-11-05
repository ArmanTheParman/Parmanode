function uninstall_btcpay_tor {

curl -s http://parman.org/downloadable/counter/parmanode_${version}_uninstall_btcpay_tor_counter >/dev/null 2>&1 &

gsed -i "/btcpayTOR/d" $macprefix/etc/tor/torrc
gsed -i "/7003/d"      $macprefix/etc/tor/torrc

sudo systemctl restart tor

installed_config_remove "btcpTOR"

success "BTCPay over Tor" "being uninstalled."
}