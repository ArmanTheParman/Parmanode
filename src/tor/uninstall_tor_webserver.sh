function uninstall_tor_webserver {
    set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor Server 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

if ! grep -q "tor-server" $ic ; then set_terminal
echo "Tor-server is not installed. Aborting uninstall." 
enter_continue
return 1
fi

sudo gsed -i "/tor-server/d" $macprefix/etc/tor/torrc
sudo gsed -i "/127.0.0.1:7001/d" $macprefix/etc/tor/torrc 
sudo rm $macprefix/etc/nginx/conf.d/tor-server.conf >/dev/null
sudo rm -rf $macprefix/var/lib/tor/tor-server
installed_conf_remove "tor-server"

set_terminal
echo "
########################################################################################

    Do you wish to delete the /tor-server directory an all its contents?
   
    Type 'yolo' to delete, or anything else to leave it, then <enter>.

########################################################################################
"
read choice
if [[ $choice == "yolo" ]] ; then
    sudo rm -rf /tor-server
fi

return 0
}
