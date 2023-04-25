function NBXplorer_service {
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

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/NBXplorer.service


sudo systemctl enable nbxplorer.service
sudo service nbxplorer start
sudo service nbxplorer status
}