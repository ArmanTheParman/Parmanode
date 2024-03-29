function install_nginx {

if cat $HOME/.parmanode/installed.conf | grep -q "nginx-end" ; then 
    set_terminal
    log "parmanode" "Nginx already installed." ; return 0 
else
    if which nginx >/dev/null 2>&1 ; then 
    set_terminal 
    log "parmanode" "Nginx already installed. (if which nginx)"
    installed_conf_add "nginx-end"     
    return 1 
    else
    installed_conf_remove "nginx-"
    fi
fi

if [[ $OS == Linux ]] ; then sudo apt-get install nginx -y ; fi

if [[ $OS == Mac ]] ; then 
    brew_check Nginx || return 1
    brew install nginx 
 fi

if which nginx >/dev/null ; then installed_conf_add "nginx-end" ; fi
return 0
}

function uninstall_nginx {
if [[ $OS == Mac ]] ; then brew services stop nginx ; brew uninstall nginx ; fi
if [[ $OS == Linux ]] ; then sudo systemctl stop nginx ; sudo apt-get purge nginx -y ; fi
installed_config_remove "nginx"
return 0
}
