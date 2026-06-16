
function make_cln_service {
cat<<EOF | sudo tee /etc/systemd/system/core-lightning.service
[Unit]
Description=Core Lightning daemon
Wants=bitcoind.service
After=bitcoind.service network-online.target
Wants=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
ExecStart=/usr/bin/lightningd --conf=$HOME/.lightning/config
Restart=on-failure
RestartSec=10
TimeoutStopSec=600

# optional hardening
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=full
ProtectHome=false

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable core-lightning.service
sudo systemctl start core-lightning.service
return 0
}
