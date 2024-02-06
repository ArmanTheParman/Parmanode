function uninstall_tor_webserver {
    set_terminal ; echo "
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

if ! grep -q "tor-server" ~/.parmanode/installed.conf ; then set_terminal
echo "Tor-server is not installed. Aborting uninstall." 
enter_continue
return 1
fi

delete_line "/etc/tor/torrc" "tor-server"
delete_line "/etc/tor/torrc" "127.0.0.1:7001" 
sudo rm /etc/nginx/conf.d/tor-server.conf >/dev/null
sudo rm -rf /var/lib/tor/tor-server
installed_conf_remove "tor-server"

set_terminal
echo "Do you wish to delete the /tor-server directory  and the"
echo "tor-server-move directory an all its contents?"
echo "Type \"yolo\" to delete, or anything else to leave it, then <enter>."
read choice
if [[ $choice == "yolo" ]] ; then
    sudo rm -rf /tor-server
    sudo rm -rf /tor-server-move
fi

return 0
}
