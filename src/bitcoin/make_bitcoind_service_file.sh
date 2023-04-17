function make_bitcoind_service_file {
set_terminal

echo "
########################################################################################

    A bitcoind service file in /etc/systemd/system/ will be created in order to 
    instruct Bitcoin Core to start automatically after a reboot.

    (The d in bitcoind means deamon, which means to run in the background.)

########################################################################################
"
enter_continue

#check if service file already exists

if [[ -e /etc/systemd/system/bitcoind.service ]]
then

while true
do
set_terminal
echo "
########################################################################################
    
        A bitcoind.service file named \"bitcoind.service\" already exists. 

	    Would you like to (r) to replace or (s) to skip (use current)?

########################################################################################
"
choose "xq" 
read choice
set_terminal

case $choice in
r|R)
    break
    ;;
s|S)
    echo "skipping..."
    enter_continue
    return 0 
    ;;
q|Q)
    exit 0
    ;;
*)
    invalid
    ;;

esac
done
fi

# inner while loop's break reaches here, otherwise exits with return=1

# make bitcoin.service and add this text...

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

# Directory creation and permissions
####################################

# Run as bitcoin:bitcoin

User=$(whoami)
Group=$(id -ng)

# /run/bitc$(id -ng)oind
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

