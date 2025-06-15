
function make_parmadesk_service {
    cat <<EOF | sudo tee /etc/systemd/system/vnc.service >$dn 2>&1
[Unit]
Description=Start VNC session
After=network.target

[Service]
Type=forking
User=parman

#-- guarantee :1 is free
ExecStartPre=-/usr/bin/vncserver -kill :1 || true
ExecStartPre=/bin/bash -c 'rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 $HOME/.vnc/*:1.* || true'

ExecStart=/usr/bin/vncserver :1 -geometry 1920x1080 -depth 24

ExecStop=/usr/bin/vncserver -kill :1

RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF | sudo tee $noVNCservicefile >$dn
[Unit]
Description=No VNC
After=network.target

[Service]
Type=simple
ExecStart=/usr/share/novnc/utils/novnc_proxy --vnc localhost:$VNC_PORT --listen $NOVNC_PORT 

Restart=on-failure
KillMode=process
User=$USER
Group=$(id -gn)

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now noVNC.service >$dn 2>&1
sudo systemctl enable --now vnc.service >$dn 2>&1

# yesorno "Do you want to have Parmadesk start on boot? If you do, you may 
#     completely lose your regular graphical interface when you log in. If
#     you don't"

}

