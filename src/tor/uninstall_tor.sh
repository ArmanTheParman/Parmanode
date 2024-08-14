function uninstall_tor {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor
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

if [[ $OS == Linux ]] ; then
sudo systemctl stop tor
sudo apt-get purge tor -y
sudo rm -rf /etc/tor /var/lib/tor >/dev/null 2>&1
elif [[ $OS == Mac ]] ; then
brew services stop tor
brew uninstall tor
rm -rf /usr/local/etc/tor/
fi


delete_line "$HOME/.bitcoin/bitcoin.conf" "onion" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "bind=127.0.0.1" 
delete_line "$HOME/.bitcoin/bitcoin.conf" "onlynet"

set_terminal
while true ; do
echo -e "
########################################################################################

    Do you also want to remove the Bitcoin$bright_blue Tor private key$orange and address? It 
    shouldn't hurt
    
                                    y)    yes

                                    n)    no

########################################################################################
"
choose x ; read choice ; set_terminal
case $choice in
n)
break
;;
y)
rm $HOME/.bitcoin/*onion* >/dev/null 2>&1
rm -rf $HOME/.sparrow/tor >/dev/null 2>&1
if [[ $OS == "Linux" ]] ; then 
    sudo rm -rf /var/lib/tor/bitcoin* >/dev/null 2>&1 
elif [[ $OS == Mac ]] ; then
    sudo rm -rf usr/local/var/lib/tor/bitcoin* >/dev/null 2>&1 
fi
break
;;
*)
invalid ;;
esac
done

installed_config_remove "tor-end"
success "Tor" "being uninstalled"
return 0
}
