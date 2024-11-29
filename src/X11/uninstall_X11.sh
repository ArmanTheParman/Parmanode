function uninstall_X11 {
toggle_X11 "off" || return 1
installed_conf_remove "X11"
success "X11 forwarding turned off"
}
