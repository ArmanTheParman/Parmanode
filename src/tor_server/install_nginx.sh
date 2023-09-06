function install_nginx {

if cat $HOME/.parmanode/installed.conf | grep -q "nginx-end" ; then 
    set_terminal
    echo "Nginx alread installed." ; enter_continue ; return 1
else
    if which nginx ; then 
    set_terminal 
    echo "Nginx already installed." ; enter_continue 
    installed_conf_add "nginx-end"     
    return 1 ; fi
fi

sudo apt-get install nginx -y
installed_conf_add "nginx-end"
enter_continue
return 0
}



function uninstall_nginx {
sudo apt-get purge nginx
installed_config_remove "nginx"
enter_continue
return 0
}
