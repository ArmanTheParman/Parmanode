function install_tor_server {

install_check "tor-server"
if [[ $? == 1 ]] ; then return 1 ; fi

if [[ $OS != "Linux" ]] ; then echo "Only available for Linux. Aborting" ; enter_continue ; return 1 ; fi

if ! which tor ; then 
    set_terminal
    echo "Tor needs to be installed in order to proceed. Do that now? y or n."
    read choice
    case $choice in y|Y|Yes|YES|yes) then install_tor ; else return 1 ;; esac 
fi

log "tor-server" "Beginning tor-server install"
installed_conf_add "tor-server-start"

echo "HiddenServiceDir /var/lib/tor/tor-server/" | sudo tee -a /etc/tor/torrc >/dev/null 2&>1
echo "HiddenServicePort 7000 127.0.0.1:7000" | sudo tee -a /etc/tor/torrc >/dev/null 2&>1

sudo systemctl restart tor

if which apache2 ; then
    set_terminal
    echo "Parmanode has detected that Apache2 is installed in your system. Parmanode is"
    echo "only configured to run with Nginx, which is not compatible with Apache2."
    echo "This installation will now abort, unless you override with \"yolo\", and"
    echo "anything else will abort. You would then need to make sure that Apache2 isn't"
    echo "running, otherwise there may be port conflicts. You have been warned, proceed"
    echo "with caution."
    echo ""
    echo "please type yolo, or anyting else to abort, then <enter>"
    echo ""
    read choice
    if [[ $choice != "yolo" ]] ; then return 1 ; fi
fi

if ! which nginx ; then
    set_terminal
    echo "Nginx needs to be installed in order to proceed. Do that now? y or n."
    read choice
    case $choice in y|Y|Yes|YES|yes) then install_nginx ; else return 1 ;; esac 
fi

if [[ -d /tor-server ]] ; then true ; else
    sudo mkdir /tor-server
    sudo chown www-data:www-data /tor-server
    sudo chmod 755 /tor-server
fi

echo "server {
	listen 7000 default_server;

	root /tor-server/;
	index index.html;

	server_name _;

	location / {
		autoindex on;
		try_files \$uri \$uri/ =404;
	}
}" | sudo tee -a /etc/nginx/conf.d/tor-server.conf

sudo systemctl restart nginx || { echo "Failed to start nginx. Aborting." ; enter_continue ; return 1 ; log "tor-server" "Failed at nginx restart" ; }
log "tor-server" "finished install"
installed_conf_add "tor-server-end"
success "A Tor server" "being installed."
return 0
}

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


function unsinstall_tor-server {
    
if ! grep -q "tor-server" ~/.parmanode/installed.conf ; then set_terminal
echo "Tor-server is not installed. Aborting uninstall." 
enter_continue
return 1
fi

delete_line "/etc/tor/torrc" "/var/lib/tor/tor-server"
delete_line "/etc/tor/torrc" "127.0.0.1:7000" 
sudo rm /etc/nginx/conf.d/tor-server.conf >/dev/null
installed_conf_remove "tor-server"

set_terminal
echo "Do you wish to delete the /tor-server directory an all its contents?"
echo "Type \"yolo\" to delete, or anything else to leave it, then <enter>."
read choice
if [[ $choice == "yolo" ]] ; then
    sudo rm -rf /tor-server
fi

set_terminal
echo "Do you wish to uninstall Nginx? \"y\" will uninstal."
read choice
if [[ $choice == "y" ]] ; then
    sudo apt-get purge nginx
fi
}
