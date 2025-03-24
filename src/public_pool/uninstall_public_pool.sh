function uninstall_public_pool {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Public Pool 
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
debug "1"
#check Docker running, esp Mac
if ! podman ps >$dn 2>&1 ; then echo -e "
########################################################################################

    Docker doesn't seem to be running. Please start it and, once it's running, hit $green 
    <enter>$orange to continue.

########################################################################################
"
choose "emq" ; read choice 
jump $choice 
case $choice in Q|q) exit 0 ;; m|M) back2main ;; esac
set_terminal
if ! podman ps >$dn 2>&1 ; then echo -e "
########################################################################################

    Docker is still$red not running$orange. 

    It can take a while to be in a 'ready state' even though you started it. Try
    again later. 
    
    Aborting. 

########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi
fi
debug "1"
stop_public_pool 
podman rm public_pool public_pool_ui >$dn 2>&1 ; debug "containers stopped and removed"
cd
sudo rm -rf $hp/public_pool $hp/public_pool_ui >$dn 2>&1
sudo rm $dp/*public_pool* $dp/.socat1_public_pool_ui $dp/.socat2_public_pool_ui >$dn 2>&1
debug "after rm"
nginx_public_pool_ui remove
nginx_stream public_pool remove
installed_conf_remove "public_pool"
success "Public Pool" "being uninstalled"
}