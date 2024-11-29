function uninstall_X11 {
toggle_X11 "off" || return 1

if [[ $OS == "Mac" ]] && which xquartz >$dn 2>&1 ; then
yesorno "Do you also want to uninstall XQuartz?" \
  && uninstall_xquartz 
fi

installed_conf_remove "X11"
success "X11 forwarding is removed"
}
