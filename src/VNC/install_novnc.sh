function install_novnc {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi


export DISPLAY_NUM=1
export GEOMETRY="1280x800"
export DEPTH=24 #for colours
export VNC_PORT=$((5900 + DISPLAY_NUM))
export NOVNC_PORT=21001

install_novnc_dependencies

# Set VNC password 
if [ ! -f "$HOME/.vnc/passwd" ]; then
    echo "Setting VNC password. You will be prompted..."
    vncpasswd
fi

# Create xstartup 
mkdir -p ~/.vnc
cat <<EOF | tee ~/.vnc/xstartup >$dn 2>&1
#!/bin/sh
xrdb $HOME/.Xresources
$DESKTOP_CMD &
EOF
chmod +x ~/.vnc/xstartup


cat <<EOF | sudo tee /etc/systemd/system/vnc.service
[Unit]
Description=Start VNC session 
After=network.target

[Service]
Type=forking
User=$USER
PAMName=login
ExecStart=/usr/bin/vncserver :1 -geometry $GEOMETRY -depth $DEPTH
ExecStop=/usr/bin/vncserver -kill :1

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | sudo tee /etc/systemd/system/noVNC.service
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
sudo systemctl enable --now noVNC.service
sudo systemctl enable --now vnc.service


# http://localhost:$NOVNC_PORT/vnc.html"

}