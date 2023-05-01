function btcpay_service {
echo "
[Unit]
Description=BtcPayServer daemon
Requires=btcpayserver.service
After=nbxplorer.service

[Service]
ExecStart=/usr/bin/dotnet run --no-launch-profile --no-build -c Release -p "$HOME/source/btcpayserver/BTCPayServer/BTCPayServer.csproj" -- $@
User=$(whoami)
Group=$(whoami)
Type=simple
PIDFile=/run/btcpayserver/btcpayserver.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/btcpayserver.service



# sudo systemctl enable btcpayserver.service
# sudo service btcpayserver start
# sudo service btcpayserver status

}
