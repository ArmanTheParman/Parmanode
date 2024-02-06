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

file="/etc/tor/torrc"
delete_line "$file" "ssh-service"
delete_line "$file" "HiddenServicePort 22 127.0.0.1:22" 

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
delete_line "$file" "HOST *.onion"
delete_line "$file" "ProxyCommand nc -x localhost:9050"
;;
esac
fi

set_terminal ; echo -e "
########################################################################################

    There's usually no need, but if you do have a need, you can delete the onion 
    address of this server, so that if you install the Tor SSH server again, a new
    onion address will be made. 

    What actually happens is$cyan /var/lib/tor/ssh-service$orange directory gets deleted.

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