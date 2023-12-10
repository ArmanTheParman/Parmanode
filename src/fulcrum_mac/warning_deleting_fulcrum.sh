function warning_deleting_fulcrum {
if [[ $debug == 1 ]] ; then return 0 ; fi
set_terminal ; echo -e "
########################################################################################

    WARNING: If you have a previous Fulcrum Docker$cyan container$orange, this installation will 
    delete it, and any Fulcrum images, but not the database.
    
    If you want to preserve any old Docker data, you should quit now, and back them up.

                              <enter>    to continue

########################################################################################
"
choose "xpmq" ; read choice
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; *) clean_containers_fulcrum ; return 0  ;; esac 
return 0
}

function clean_containers_fulcrum {
docker stop fulcrum >/dev/null 2>&1 && log "fulcrum" "container stopped"
docker rm fulcrum >/dev/null 2>&1 && log "fulcrum" "container removed"
docker rmi fulcrum >/dev/null 2>&1 && log "fulcrum" "docker image deleted"
}