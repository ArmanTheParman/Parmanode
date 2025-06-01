function install_vnc {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

yesorno "VNC (Virtual Network Computing) allows you to view your ParmanodL's desktop 
    environment through the browswer of another computer, giving you full access. 
    
    Instead of SSH log in (which is fine most of the time), you can use the browswer
    instead.  The layout will not be identical, but it's mostly good enough. For 
    example, right clicks and pasting might not work as expected 100% of the time. 
    You'll still be able to drag and drop files around, but not from the browswer to 
    the host desktop.  
$green
    Install it?$orange" || return 1 

clear

export DISPLAY_NUM=1
export GEOMETRY="1920×1080"
export DEPTH=24 #for colours
export VNC_PORT=$((5900 + DISPLAY_NUM))
export NOVNC_PORT=21000

install_novnc_dependencies

# Create xstartup 
mkdir -p ~/.vnc ; installed_conf_add "vnc-start"
mkdir -p $hp/vnc

cat <<EOF | tee ~/.vnc/xstartup >$dn 2>&1
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startxfce4
EOF
chmod +x ~/.vnc/xstartup

# Set VNC password 
if [ ! -f "$HOME/.vnc/passwd" ]; then
    clear
    echo -e "Setting VNC password...$red max 8 characters.$orange
    \rThis is the password you will use to log in to Parmanode via the browser.\n
    \rYou will be offered the option to set a 'view only password' which is
    \rcompletely optional, allowing you to enter sessions where you can't  
    \rinteract with the computer, only view it's contents, eg for presentations.\n"
    vncpasswd
fi


cat <<EOF | sudo tee /etc/systemd/system/vnc.service >$dn 2>&1
[Unit]
Description=Start VNC session
After=network.target

[Service]
Type=forking
User=parman

#-- guarantee :1 is free
ExecStartPre=/bin/bash -c '/usr/bin/vncserver -kill :1 >/dev/null 2>&1 || true; rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 $HOME/.vnc/*:1.* || true'

ExecStart=/usr/bin/vncserver :1 -geometry 1920x1080 -depth 24

ExecStop=/usr/bin/vncserver -kill :1

RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

EOF

cat <<EOF | sudo tee /etc/systemd/system/noVNC.service >$dn 2>&1
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
vnc_tor
make_ssl_certificates vnc
make_vnc_nginx

# http://localhost:$NOVNC_PORT/vnc.html"
installed_conf_add "vnc-end"
installed_conf_remove "vnc-start"
success "Virtual Network Computing installed"
return 0
}

