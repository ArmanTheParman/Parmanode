function uninstall_nostrrelay {
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Nostr Relay 
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

set_terminal

if ! docker ps >/dev/null 2>&1 ; then
announce "docker not running. Aborting."
return 1
fi

docker stop nostrrelay
docker rm nostrrelay

rm -rf $hp/nostrrelay 2>/dev/null

installed_conf_remove "nostrrelay"
success "Nostr Relay has been uninstalled"
}