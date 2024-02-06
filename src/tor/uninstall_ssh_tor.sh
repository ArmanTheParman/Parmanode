function uninstall_ssh_tor {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall SSH Tor
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
delete_line "$file" "HiddenServiceDir /var/lib/tor/ssh-server/"
delete_line "$file" "HiddenServicePort 22 127.0.0.1:22" 

sudo systemctl restart tor ssh

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

installed_conf_remove "sshtor"
success "SSH Tor" "being uninstalled"
}