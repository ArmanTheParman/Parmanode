function make_socat_service {
#renamed and changed from make_socat_service listen. Two step forward not needed.
echo "[Unit]
Description=Socat SSL to TCP Forwarding Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat OPENSSL-LISTEN:50006,reuseaddr,fork,cert=$HOME/.electrs/cert.pem,key=$HOME/.electrs/key.pem,verify=0 TCP:127.0.0.1:50005
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
}" | sudo tee /etc/systemd/system/socat.service >/dev/null 2>&1

sudo systemctl daemon-reload >/dev/null 2>&1
sudo systemctl enable socat.service >/dev/null 2>&1
sudo systemctl start socat.service >/dev/null 2>&1
}
