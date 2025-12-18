# Variables can't be left in this file, they are all interpreted, then
# writting to the file
# Much of the text is from the sample service file from Bitcoin Core developers.

function make_bitcoind_service_file { debugf
if [[ $btcpayinstallsbitcoin == "true" ]] ; then return 0 ; fi

file=$(mktemp)

echo "[Unit]
Description=Bitcoin daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/scripts/mount_check.sh
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
" | tee "$file" >$dn || enter_continue "Failed to write bitcoind.service file"

if [[ $1 == "setup" ]] ; then #for parmanode installation
    sudo chown root:root "$file"
    sudo chmod 655 "$file"
    sudo mv "$file" /usr/local/parmanode/bitcoind.service
    return 0
elif [[ $parmaview == 1 ]] ; then #for parmaview method of bitcoin install
    sudo cp -r /usr/local/parmanode/bitcoind.service /etc/systemd/system/bitcoind.service
else #for regular bitcoin install using backend parmanode
    sudo mv "$file" /etc/systemd/system/bitcoind.service 
fi

sudo systemctl daemon-reload 
sudo systemctl disable bitcoind.service >$dn 2>&1
sudo systemctl enable bitcoind.service >$dn 2>&1
}

