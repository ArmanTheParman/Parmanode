function uninstall_xquartz {
    stop_xquartz
    sudo rm -rf /Applications/Utilities/XQuartz.app >$dn 2>&1
    sudo rm -rf /opt/X11 >$dn 2>&1
    sudo rm -rf /private/etc/X11 >$dn 2>&1
    sudo rm -rf /usr/X11 >$dn 2>&1
    sudo rm -rf /usr/X11R6 >$dn 2>&1
    sudo rm -rf /usr/lib/X11 >$dn 2>&1
    sudo rm -rf /Library/Fonts/X11 >$dn 2>&1
    sudo rm -rf ~/.Xauthority ~/.xinitrc ~/.xserverrc >$dn 2>&1
    installed_conf_remove "xquartz"
    success "XQuartz has been removed"
}