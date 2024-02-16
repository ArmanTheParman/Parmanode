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
#check Docker running, esp Mac
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker doesn't seem to be running. Please start it and, once it's running, hit $green 
    <enter>$orange to continue.

########################################################################################
"
choose "emq"
read choice ; case $choice in Q|q) exit 0 ;; m|M) back2main ;; esac
set_terminal
if ! docker ps >/dev/null 2>&1 ; then echo -e "
########################################################################################

    Docker is still$red not running$orange. 

    It can take a while to be in a 'ready state' even though you started it. Try
    again later. 
    
    Aborting. 

########################################################################################
"
enter_continue
return 1
fi
fi
stop_public_pool >/dev/null 2>&1
docker rm public_pool public_pool_ui ; debug "containers stopped and removed"
delete_line $bc "zmqpubrawblock=tcp://\*:5000" >/dev/null 2>&1
cd
rm -rf $hp/public_pool $hp/public_pool_ui >/dev/null 2>&1
debug "after rm"
nginx_public_pool_ui remove
installed_conf_remove "public_pool"
debug "before end"
success "Public Pool" "being uninstalled"
}