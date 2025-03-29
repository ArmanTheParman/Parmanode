function install_nginx {

if cat $HOME/.parmanode/installed.conf | grep -q "nginx-end" ; then 
    set_terminal
    log "parmanode" "Nginx already installed." ; return 0 
else
    if sudo which nginx >$dn 2>&1 ; then 
    set_terminal 
    installed_conf_add "nginx-end"     
    return 1 
    else
    installed_conf_remove "nginx-"
    fi

    if [[ $OS == "Mac" ]] ; then 
        brew_check Nginx || return 1
        brew install nginx 
    elif [[ $OS == "Linux" ]] ; then
        sudo apt-get update -y && sudo apt-get install nginx-full -y 
        sudo rm /etc/nginx/sites-enabled/default
        sudo systemctl restart nginx
    fi

fi

if sudo which nginx >$dn ; then installed_conf_add "nginx-end" ; fi
return 0

}

