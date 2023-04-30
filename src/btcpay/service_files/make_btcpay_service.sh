function make_btcpay_service.sh {

echo "[Unit]
Description=NBXplorer daemon
Requires=bitcoind.service
After=bitcoind.service

[Service]
ExecStart=/usr/bin/dotnet "/home/satoshi/source/NBXplorer/NBXplorer/bin/Release/netcoreapp2.1/NBXplorer.dll" -c /home/satoshi/.nbxplorer/Main/settings.config
User=satoshi
Group=satoshi
Type=simple
PIDFile=/run/nbxplorer/nbxplorer.pid
Restart=on-failure

PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
PrivateDevices=true

[Install]" | sudo tee /usr/lib/systemd/system/btcpay.service \
&& log "btcpay" "btcpay service file made"

return 0
}