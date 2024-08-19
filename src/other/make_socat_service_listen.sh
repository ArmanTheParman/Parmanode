function make_socat_service_listen {
echo "[Unit]
Description=Socat SSL to TCP Forwarding Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50055
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
}" | sudo tee /etc/systemd/system/socat_listen.service >/dev/null 2>&1

sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl enable socat_listen.service >/dev/null 2>&1
sudo systemctl start socat_listen.service >/dev/null 2>&1
}
