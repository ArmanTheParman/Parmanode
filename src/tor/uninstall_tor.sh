function uninstall_tor {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor
$orange 
    Parmanode will uninstall Tor from your system. Hit <enter> to proceed.

########################################################################################
"
choose "epq" ; read
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; esac

sudo systemctl stop tor
sudo apt-get purge tor -y
sudo rm -rf /etc/tor /var/lib/tor >/dev/null 2>&1

delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

if [[ $OS == "Linux" ]] ; then 
    sudo rm -rf /var/lib/tor/bitcoin* >/dev/null 2>&1 
    rm $HOME/.bitcoin/*onion* >/dev/null 2>&1
fi

rm -rf $HOME/.sparrow/tor >/dev/null 2>&1

installed_config_remove "tor-end"

success "Tor" "being uninstalled"
return 0
}
