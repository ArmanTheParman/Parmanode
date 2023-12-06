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

cd $hp/mempool/docker && docker-compose down
cd $hp && rm -rf ./mempool/
sudo rm -rf /var/lib/tor/mempool-service >/dev/null 2>&1
delete_line "/etc/tor/torrc" "mempool-service"
delete_line "/etc/tor/torrc" "127.0.0.1:8180"
installed_config_remove "mempool-"
success "Mempool" "being uninstalled"

}