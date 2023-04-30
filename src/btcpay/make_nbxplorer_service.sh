function make_nbxplorer_service {
docker exec -it -u root btcpay /bin/bash -c \
"echo \"[Unit]
Description=NBXplorer daemon

[Service]
ExecStart=/usr/bin/dotnet \"/home/parman/NBXplorer/NBXplorer/bin/Release/netcoreapp2.1/NBXplorer.dll\" -c /home/parman/.nbxplorer/Main/settings.config
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
WantedBy=multi-user.target\" | sudo tee /etc/systemd/system/nbxplorer.service" \ 
&& log "nbxplorer" "nbxplorer service file made"

return 0
}