function make_bitcoind_service_file {

echo "[Unit]
Description=Bitcoin daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/mount_check.sh
ExecStart=/usr/local/bin/bitcoind -daemon \\
                            -pid=/run/bitcoind/bitcoind.pid \\
                            -conf=$HOME/.bitcoin/bitcoin.conf \\
                            -datadir=$HOME/.bitcoin

# Make sure the config directory is readable by the service user
PermissionsStartOnly=true

# Process management
####################

Type=forking
PIDFile=/run/bitcoind/bitcoind.pid
Restart=on-failure
TimeoutStartSec=infinity
TimeoutStopSec=600


User=$(whoami)
Group=$(id -ng)

RuntimeDirectory=bitcoind
RuntimeDirectoryMode=0710

# /etc/bitcoin
ConfigurationDirectory=bitcoin
ConfigurationDirectoryMode=0710

# /var/lib/bitcoind
StateDirectory=bitcoind
StateDirectoryMode=0710

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
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/bitcoind.service > /dev/null

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages

sudo systemctl daemon-reload 
sudo systemctl disable bitcoind.service >/dev/null 2>&1
sudo systemctl enable bitcoind.service >/dev/null 2>&1

return 0
}

