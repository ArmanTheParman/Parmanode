function warning_deleting_fulcrum {

set_terminal ; echo "
########################################################################################

    WARNING: If you have a previous Fulcrum Docker container, this installation will 
    delete it, and any Fulcrum images. We're starting fresh, too bad. If you want to 
    preserve any old data, you should quit now, and back them up. If you don't know 
    how... see internet  ;p

                              <enter>    to continue

########################################################################################
"
choose "xpq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; *) clean_containers_fulcrum ; return 0  ;; esac 
return 0
}

function clean_containers_fulcrum {
docker stop fulcrum >/dev/null 2>&1 && log "fulcrum" "container stopped"
docker rm fulcrum >/dev/null 2>&1 && log "fulcrum" "container removed"
docker rmi fulcrum >/dev/null 2>&1 && log "fulcrum" "docker image deleted"
}