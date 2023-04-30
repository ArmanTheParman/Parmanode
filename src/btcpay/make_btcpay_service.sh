function make_btcpay_service.sh {
docker exec -it -u root btcpay /bin/bash -c \
"echo \"[Unit]
Description=NBXplorer daemon
Requires=bitcoind.service
After=bitcoind.service

[Service]
ExecStart=/usr/bin/dotnet \"/home/parman/parmanode/NBXplorer/NBXplorer/bin/Release/netcoreapp2.1/NBXplorer.dll\" -c /home/parman/.nbxplorer/Main/settings.config
User=parman
Group=parman
Type=simple
PIDFile=/run/nbxplorer/nbxplorer.pid
Restart=on-failure

PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
PrivateDevices=true

[Install]\" | sudo -a tee /etc/systemd/system/btcpay.service" >/dev/null 2>&1 \
&& log "btcpay" "btcpay service file made"

return 0
}