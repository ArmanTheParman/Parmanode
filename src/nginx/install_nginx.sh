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

    if [[ $OS == Mac ]] ; then 
        brew_check Nginx || return 1
        brew install nginx 
    else
        sudo apt-get update -y && sudo apt-get install nginx-full -y 
    fi

fi

if which nginx >/dev/null ; then installed_conf_add "nginx-end" ; fi
return 0

}

