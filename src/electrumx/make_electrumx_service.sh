function make_electrumx_service {

cat << EOF | sudo tee /etc/systemd/system/electrumx.service >/dev/null 2>&1
[Unit]
Description=Electrumx
After=network.target

[Service]
EnvironmentFile=$hp/electrumx/electrumx.conf
ExecStart=$HOME/.local/bin/electrumx_server
ExecStop=$HOME/.local/bin/electrumx_rpc -p 8000 stop
User=$USER
LimitNOFILE=8192
TimeoutStopSec=30min

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable electrumx.service

}