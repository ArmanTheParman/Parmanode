function uninstall_mempool {
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Mempool?
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

if ! docker ps > /dev/null 2>&1 ; then
announce "Docker needs to be running. Aborting."
return 1
fi

cd $hp/mempool/docker && docker compose down
#need sudo, some dirs have container permissions
cd $hp && sudo rm -rf ./mempool/
delete_line "/etc/tor/torrc" "mempool-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8180"
installed_config_remove "mempool-"
success "Mempool" "being uninstalled"

}