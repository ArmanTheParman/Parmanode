function install_tor_webserver {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! which tor >$dn ; then install_tor ; fi


set_terminal

if ! which tor >$dn 2>&1 ; then 
    set_terminal
    echo "Tor needs to be installed in order to proceed. Do that now? y or n."
    read choice
    case $choice in 
        y|Y|Yes|YES|yes) 
            install_tor ;; 
        *) 
            return 1 ;;
    esac
fi

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


log "tor-server" "Beginning tor-server install"
installed_conf_add "tor-server-start"

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >$dn 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >$dn 2>&1
fi

echo "HiddenServiceDir /var/lib/tor/tor-server/" | sudo tee -a /etc/tor/torrc >$dn 2>&1
echo "HiddenServicePort 7001 127.0.0.1:7001" | sudo tee -a /etc/tor/torrc >$dn 2>&1
sudo systemctl restart tor


if ! which nginx >$dn 2>&1 ; then
    set_terminal
    echo "Nginx needs to be installed in order to proceed. Do that now? y or n."
    read choice
    case $choice in y|Y|Yes|YES|yes) install_nginx ; return 0 ;; esac 
fi

if [[ ! -d /tor-server ]] ; then 
    sudo mkdir /tor-server 
    sudo chown -R www-data:www-data /tor-server
    sudo chmod -R 755 /tor-server
fi

echo "server {
	listen 7001 default_server;

	root /tor-server/;
	index index.html;

	server_name _;

	location / {
		autoindex on; # autoindex tag
		try_files \$uri \$uri/ =404;
	}
}" | sudo tee -a /etc/nginx/conf.d/tor-server.conf >$dn 2>&1

sudo systemctl restart nginx || { echo "Failed to start nginx. Aborting." ; enter_continue ; return 1 ; log "tor-server" "Failed at nginx restart" ; }
log "tor-server" "finished install"
installed_conf_add "tor-server-end"
success "A Tor server" "being installed."
return 0
}



