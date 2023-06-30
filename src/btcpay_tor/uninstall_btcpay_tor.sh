function uninstall_btcpay_tor {

curl http://parman.org/downloadable/counter/parmanode_btcpTOR_uninstall.html >/dev/null 2>&1 &

delete_line "/etc/tor/torrc" "btcpayTOR"
delete_line "/etc/tor/torrc" "7003"
sudo rm -rf /var/lib/tor/btcpayTOR-server/ >/dev/null 2>&1

sudo systemctl restart tor

installed_config_remove "btcpTOR"

success "BTCPay over Tor" "being uninstalled."
}