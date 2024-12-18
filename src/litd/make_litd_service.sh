function make_litd_service {

if [[ $bitcoin_choice_with_litd == remote ]] ; then
    unset binds after
else
    binds="BindsTo=bitcoind.service"
    after="After=bitcoind.service"
fi

debug "$bitcoin_choice_with_litd"

echo "[Unit]
Description=lit Daemon
$binds
$after
[Service]
ExecStart=/usr/local/bin/litd
ExecStop=/bin/kill -s SIGINT \$MAINPID
User=$(whoami)
Restart=on-failure
RestartSec=10
LimitNOFILE=4096
TimeoutStopSec=60
PrivateDevices=true
MemoryDenyWriteExecute=true
[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/litd.service >$dn 2>&1

sudo systemctl daemon-reload      >$dn 2>&1
sudo systemctl enable litd.service >$dn 2>&1
sudo systemctl start  litd.service >$dn 2>&1

unset binds after
return 0
}
