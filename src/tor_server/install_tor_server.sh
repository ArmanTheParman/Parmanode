function install_tor_server {

if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi

if ! which tor >/dev/null ; then install_tor ; fi

if [[ -z $1 ]] ; then
    install="ts"
else
    install="$1"
fi


set_terminal

if ! which tor >/dev/null 2>&1 ; then 
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

if [[ $install == "ts" ]] ; then
install_check "tor-server"
if [[ $? == 1 ]] ; then return 1 ; fi

log "tor-server" "Beginning tor-server install"
curl -s https://parman.org/parmanode_${version}_install_tor_server_counter >/dev/null 2>&1 &
installed_conf_add "tor-server-start"

if ! sudo cat /etc/tor/torrc | grep "# Additions by Parmanode..." >/dev/null 2>&1 ; then
echo "# Additions by Parmanode..." | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

echo "HiddenServiceDir /var/lib/tor/tor-server/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
echo "HiddenServicePort 7001 127.0.0.1:7001" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
sudo systemctl restart tor


if ! which nginx >/dev/null 2>&1 ; then
    set_terminal
    echo "Nginx needs to be installed in order to proceed. Do that now? y or n."
    read choice
    case $choice in y|Y|Yes|YES|yes) install_nginx ; return 0 ;; esac 
fi

if [[ -d /tor-server ]] ; then true ; else
    sudo mkdir /tor-server /tor-server-move
    sudo chown -R www-data:www-data /tor-server
    sudo chmod -R 755 /tor-server
    sudo chown -R www-data:www-data /tor-server-move
    sudo chmod -R 755 /tor-server-move
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
}" | sudo tee -a /etc/nginx/conf.d/tor-server.conf >/dev/null 2>&1

sudo systemctl restart nginx || { echo "Failed to start nginx. Aborting." ; enter_continue ; return 1 ; log "tor-server" "Failed at nginx restart" ; }
log "tor-server" "finished install"
installed_conf_add "tor-server-end"
success "A Tor server" "being installed."

fi # end if install = ts


if [[ $install == "btcpay" ]] ; then

install_check "btcpTOR"
if [[ $? == "1" ]] ; then return 1 ; fi

log "btcpTOR" "Beginning btcpTOR install"
curl -s http://parman.org/parmanode_${version}_btcpaytor_install_counter >/dev/null 2>&1 &
installed_conf_add "btcpTOR-start"

if [ -z $selfIP ] ; then
echo "HiddenServiceDir /var/lib/tor/btcpayTOR-server/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
echo "HiddenServicePort 7003 127.0.0.1:23001" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
else
echo "HiddenServiceDir /var/lib/tor/btcpayTOR-server/" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
echo "HiddenServicePort 7003 $selfIP:$selfPort" | sudo tee -a /etc/tor/torrc >/dev/null 2>&1
fi

sudo systemctl restart tor

installed_conf_add "btcpTOR-end"

success "BTCPay over Tor" "being installed."

fi # end if install=btcpay

return 0
}



