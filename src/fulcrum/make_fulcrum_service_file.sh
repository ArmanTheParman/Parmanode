function make_fulcrum_service_file {
echo "[Unit]
Description=Fulcrum_daemon
After=network-online.target
Wants=network-online.target

[Service]
ExecStartPre=$HOME/.parmanode/mount_check.sh
ExecStart=/usr/local/bin/Fulcrum $HOME/.fulcrum/fulcrum.conf >$HOME/.fulcrum/fulcrum.log 2>&1
TimeoutStopSec=90s
KillSignal=SIGTERM

User=$(whoami)
Group=$(id -ng)

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/fulcrum.service >$dn 

#tee used instead of echo because redirection operator after sudo echo loses sudo privilages

sudo systemctl daemon-reload 
sudo systemctl disable fulcrum.service >$dn 2>&1
sudo systemctl enable fulcrum.service >$dn 2>&1

return 0
}

