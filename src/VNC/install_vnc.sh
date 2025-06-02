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
export noVNCservicefile="/etc/systemd/system/noVNC.service"

install_novnc_dependencies

# Create xstartup 
mkdir -p ~/.vnc ; installed_conf_add "vnc-start"
mkdir -p $hp/vnc

cat <<EOF | tee ~/.vnc/xstartup >$dn 2>&1
#!/bin/sh
unset SESSION_MANAGER DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP=MATE # tells autostart apps this is an MATE session, otherwise errors can happen
export DISPLAY=:1
exec mate-session
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

while true ; do
    if sudo test -f /usr/share/novnc/utils/novnc_proxy ; then 
        break 
    elif sudo test -f  /usr/share/novnc/utils/launch ; then 
        sudo gsed -i 's/novnc_proxy/launch/' $noVNCservicefile >$dn 2>&1    
        break
    elif sudo grep -R "try to find websockify " /usr/share/novnc/utils/ ; then
        name=$(cd /usr/share/novnc/utils >$dn 2>&1 && sudo grep -R "try to find websockify " ./ | head -n1 | cut -d  ' ' -f1 | cut -d : -f1 | cut -d / -f2)
        name=$(basename $name)
        sudo gsed -i "s/novnc_proxy/$name/" $noVNCservicefile >$dn 2>&1   
        break
    else
        sudo gsed -i "s/ExecStart.*$/ExecStart=\/usr\/bin\/websockify --web=\/usr\/share\/novnc $NOVNC_PORT localhost:$VNC_PORT/" $noVNCservicefile >$dn 2>&1
        break
    fi
done

sudo systemctl daemon-reload
sudo systemctl enable --now noVNC.service >$dn 2>&1
sudo systemctl enable --now vnc.service >$dn 2>&1
vnc_tor
make_ssl_certificates vnc
make_vnc_nginx

# http://localhost:$NOVNC_PORT/vnc.html"
installed_conf_add "vnc-end"
installed_conf_add "vnc-vJ3
installed_conf_remove "vnc-start"
success "Virtual Network Computing installed"
return 0
}