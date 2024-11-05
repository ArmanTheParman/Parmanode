function uninstall_torssh {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor SSH
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

file="$macprefix/etc/tor/torrc"
sudo gsed -i "/ssh-service/d" $file 
sudo gsed -i "/HiddenServicePort 22 127.0.0.1:22/d" $file 
sudo systemctl restart tor ssh


if ! grep -q "sshtor-end" < $ic ; then #in case tor service made but install was partial
# then don't delete the service, making it could have been the delay and cause for failure.
set_terminal ; echo -e "
########################################################################################

    Remove the SSH Tor client functionality too? (removes config settings from
    $HOME/.ssh/config)
$green
                          y)      yeah, whatever
$red
                          n)      nah, that's going to be handy later
$orange
########################################################################################
"
read choice
case $choice in
y)
file="$HOME/.ssh/config"
sudo gsed -i "/HOST *.onion/d" $file 
sudo gsed -i "/ProxyCommand nc -x localhost:9050/d" $file 
;;
esac
fi

set_terminal ; echo -e "
########################################################################################

    There's usually no need, but if you do have a need, you can delete the onion 
    address of this server, so that if you install the Tor SSH server again, a new
    onion address will be made. 

    What actually happens is$cyan $macprefix/var/lib/tor/ssh-service$orange directory gets deleted.

    Delete it?    $red 
                      y) yes
$green
                      n) nah, no need
                       $orange

########################################################################################
"
read choice
case $choice in
y)
sudo rm -rf /var/lib/tor/ssh-service/
;;
esac

installed_conf_remove "torssh"
success "SSH Tor" "being uninstalled"
}