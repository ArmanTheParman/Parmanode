function install_nginx {

if cat $HOME/.parmanode/installed.conf | grep -q "nginx-end" ; then 
    set_terminal
    log "parmanode" "Nginx already installed." ; return 1
else
    if which nginx ; then 
    set_terminal 
    log "parmanode" "Nginx already installed."
    installed_conf_add "nginx-end"     
    return 1 ; fi
fi

sudo apt-get install nginx -y
installed_conf_add "nginx-end"
return 0
}

function uninstall_nginx {
sudo apt-get purge nginx
installed_config_remove "nginx"
return 0
}
