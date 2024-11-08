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
elif [[ $OS == Mac ]] ; then
brew services stop tor
brew uninstall tor
fi

sudo rm -rf $macprefix/etc/tor $macprefix/var/lib/tor >/dev/null 2>&1

sudo gsed -i "/onion/d" $bc 
sudo gsed -i "/bind=127.0.0.1/d" $bc
sudo gsed -i  "/onlynet/d" $bc

set_terminal
if [[ -e $HOME/.bitcoin/tor ]] || [[ -e $macprefix/var/lib/tor/bitcoin ]] ; then
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
sudo rm $HOME/.bitcoin/*onion* >/dev/null 2>&1
sudo rm -rf $HOME/.sparrow/tor >/dev/null 2>&1
sudo rm -rf $macprefix/var/lib/tor/bitcoin* >/dev/null 2>&1 
break
;;
*)
invalid ;;
esac
done
fi

sudo rm $HOME/.tornoticefile.log >$dn 2>&1
sudo rm $HOME/.torinfofile.log >$dn 2>&1

installed_config_remove "tor-end"
success "Tor" "being uninstalled"
return 0
}
