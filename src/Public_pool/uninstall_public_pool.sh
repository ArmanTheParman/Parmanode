function uninstall_public_pool {

set_terminal ; echo -e "

########################################################################################
$cyan
                                 Uninstall Public Pool 
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

stop_public_pool 
docker rm public_pool public_pool_ui ; debug "containers stopped and removed"
delete_line $bc "zmqpubrawblock=tcp://*:5000" >/dev/null 2>&1
cd
rm -rf $hp/public_pool $hp/public_pool_ui >/dev/null 2>&1
debug "after rm"
nginx_public_pool remove
installed_conf_remove "public_pool"
success "Public Pool" "being uninstalled"
}