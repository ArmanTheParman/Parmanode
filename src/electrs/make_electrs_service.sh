function make_electrs_service {
if [[ $OS == Mac ]] ; then return ; fi

echo "
[Unit]
Description=Electrs
After=bitcoind.service

[Service]
WorkingDirectory=/home/$USER/parmanode/electrs
ExecStart=/home/$USER/parmanode/electrs/target/release/electrs --conf /home/$USER/.electrs/config.toml
User=$USER
Group=$(id -ng)
Type=simple
KillMode=process
TimeoutSec=60
Restart=always
RestartSec=60

Environment=\"RUST_BACKTRACE=1\"

# Hardening measures
PrivateTmp=true
ProtectSystem=full
NoNewPrivileges=true
MemoryDenyWriteExecute=true

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/electrs.service >$dn 2>&1

sudo systemctl daemon-reload >$dn
sudo systemctl enable electrs.service >$dn

}