function install_parmadesk {
if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
if [[ $computer_type == "Pi" ]] ; then announce "Installing ParmaDesk on a Pi might break your ability to
   run a normal graphical environment connected to a monitor. It can be fixed but it's tricky.
   You should continue only if you want to use your Pi in a headless way.

   Continue? " || return 0
fi

yesorno "ParmaDesk is a VNC (Virtual Network Computing) tool that allows you to 
    view your ParmanodL's desktop environment through the browswer of another 
    computer, giving you full access. 
    
    Instead of SSH log in (which is fine most of the time), you can use the browswer
    instead. The layout will not be identical, but it's mostly good enough. For 
    example, right clicks and pasting might not work as expected 100% of the time. 
    
    You'll be able to drag and drop files around, but not from the browswer to 
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
export install=parmadesk

install_parmadesk_dependencies

# Create xstartup 
mkdir -p ~/.vnc ; installed_conf_add "parmadesk-start"
mkdir -p $hp/parmadesk

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
    vncpasswd #this is not a custom parmanode function
fi
debug 1
sound_error_suppression
debug 2
#make_parmadesk_log_cleanup_service
debug 3
make_parmadesk_service
debug 4
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
debug 5

parmadesk_tor
debug 6
make_ssl_certificates parmadesk
debug 7
make_parmadesk_nginx
debug 8
# http://localhost:$NOVNC_PORT/vnc.html"
installed_conf_add "parmadesk-end"
installed_conf_add "parmadesk-vJ4"
installed_conf_remove "parmadesk-start"

#remove this later  when fix removed from temp_patch()
touch $dp/.vncfixed 
success "ParmaDesk Virtual Network Computing installed"
return 0
}
