function make_btcrpcexplorer_service {

echo "[Unit]
Description=BTC RPC Explorer
After=bitcoind.service
PartOf=bitcoind.service

[Service]
WorkingDirectory=$HOME/parmanode/btc-rpc-explorer
ExecStart=/usr/bin/btc-rpc-explorer
User=$USER

Restart=always
RestartSec=30

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/btcrpcexplorer.service >$dn 2>&1

sudo systemctl enable btcrpcexplorer.service >$dn 2>&1
}