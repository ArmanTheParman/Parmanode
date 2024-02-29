function make_socat_service_publish {
echo "[Unit]
Description=Socat SSL to TCP Forwarding Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/socat TCP-LISTEN:50055,reuseaddr,fork TCP:127.0.0.1:50005
Restart=on-failure
RestartSec=10
KillMode=process

[Install]
WantedBy=multi-user.target
}" | sudo tee /etc/systemd/system/socat_publish.service >/dev/null 2>&1


sudo systemctl daemon-reload
sudo systemctl enable socat_publish.service
sudo systemctl start socat_publish.service
}
