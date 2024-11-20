function uninstall_torssh {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Tor SSH
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

file="$macprefix/etc/tor/torrc"
sudo gsed -i "/ssh-service/d" $file 
sudo gsed -i "/HiddenServicePort 22 127.0.0.1:22/d" $file 
sudo systemctl restart tor ssh


if ! grep -q "sshtor-end" $ic ; then #in case tor service made but install was partial
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