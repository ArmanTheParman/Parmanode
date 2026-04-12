function make_eps_service {
if [[ $OS == "Mac" ]] ; then return ; fi
file=$(mktemp)
echo "
[Unit]
Description=EPS
After=bitcoind.service

[Service]
WorkingDirectory=/home/$USER/parmanode/eps
ExecStart=$HOME/.local/bin/electrum-personal-server $hp/eps/config.ini
User=$USER
Group=$(id -ng)
Type=simple
KillMode=process
TimeoutSec=60
Restart=on-failure
RestartSec=300

Environment=\"RUST_BACKTRACE=1\"

# Hardening measures
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
MemoryDenyWriteExecute=true

# Logging
StandardOutput=append:/home/$USER/.eps/run_eps.log
StandardError=append:/home/$USER/.eps/run_eps.log

[Install]
WantedBy=multi-user.target" | tee "$file" >$dn 2>&1

if [[ $1 == "setup" ]] ; then
    sudo chown root:root "$file"
    sudo chmod 644 "$file"
    sudo mv "$file" /usr/local/parmanode/eps.service
elif [[ $parmaview == 1 ]] ; then
    sudo mv /usr/local/parmanode/eps.service /etc/systemd/system/
else
    sudo mv "$file" /etc/systemd/system/eps.service 
fi

sudo systemctl daemon-reload >$dn 2>&1
sudo systemctl enable --now eps.service >$dn 2>&1

}