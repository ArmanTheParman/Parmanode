function make_lnd_service {

if [[ $bitcoin_choice_with_lnd == remote ]] ; then
    unset binds after
else
    binds="BindsTo=bitcoind.service"
    after="After=bitcoind.service"
fi

echo "[Unit]
Description=LND Lightning Network Daemon
$binds
$after
[Service]

# Service execution
###################
ExecStart=/usr/local/bin/lnd
ExecStop=/usr/local/bin/lncli stop

# Process management
####################
Type=simple
Restart=always
RestartSec=30
TimeoutSec=240
LimitNOFILE=128000

# Directory creation and permissions
####################################
User=$(whoami)

# /run/lightningd
RuntimeDirectory=lightningd
RuntimeDirectoryMode=0710

# Hardening measures
####################
# Provide a private /tmp and /var/tmp.
PrivateTmp=true

# Mount /usr, /boot/ and /etc read-only for the process.
ProtectSystem=full

# Disallow the process and all of its children to gain
# new privileges through execve().
NoNewPrivileges=true

# Use a new /dev namespace only populated with API pseudo devices
# such as /dev/null, /dev/zero and /dev/random.
PrivateDevices=true

# Deny the creation of writable and executable memory mappings.
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/lnd.service >$dn 2>&1

sudo systemctl daemon-reload      >$dn 2>&1
sudo systemctl enable lnd.service >$dn 2>&1
sudo systemctl start  lnd.service >$dn 2>&1

unset binds after
return 0
}
