[Unit]
Description=BtcPayServer daemon
Requires=btcpayserver.service
After=nbxplorer.service

[Service]
ExecStart=/usr/bin/dotnet run --no-launch-profile --no-build -c Release --project "/home/satoshi/source/btcpayserver/BTCPayServer/BTCPayServer.csproj" -- $@
User=satoshi
Group=satoshi
Type=simple
PIDFile=/run/btcpayserver/btcpayserver.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target




sudo systemctl enable btcpayserver.service
sudo service btcpayserver start
sudo service btcpayserver status