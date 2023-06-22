function install_nginx {

if which nginx ; then set_terminal ; echo "Nginx already installed." ; enter_continue ; return 1 ; fi

sudo apt-get install nginx
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
