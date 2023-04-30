function make_nbxplorer_service {
docker exec -it -u root btcpay /bin/bash -c \
"echo \"[Unit]
Description=NBXplorer daemon

[Service]
ExecStart=
User=parman
Group=parman
Type=simple
PIDFile=/run/nbxplorer/nbxplorer.pid
Restart=on-failure

PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
PrivateDevices=true

[Install]
WantedBy=multi-user.target\" | sudo -a tee /etc/systemd/system/nbxplorer.service" >/dev/null 2>&1 \
&& log "nbxplorer" "nbxplorer service file made"

return 0
}