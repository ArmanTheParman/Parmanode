
function make_parmadesk_log_cleanup_service {
sudo test -f parmadesk_log_cleanup.service >$dn 2>&1 && return 0 

cat <<EOF | sudo tee /etc/systemd/system/parmadesk_log_cleanup.service >$dn 2>&1
[Unit]
Description=ParmaDesk noisy log cleanup

[Service]
Type=forking
ExecStart=/bin/bash -c 'for f in /home/$USER/.vnc/*.log; do > "\$f"; done'

Restart=always
RestartSec=40000
User=$USER
Group=$(id -gn)

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable parmadesk_log_cleanup.service >$dn 2>&1
}
