function uninstall_fulcrum_docker {
if [[ $(uname) == Linux ]] ; then return 0 ; fi
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Fulcrum? 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal
if [[ $choice == y ]] ; then true ; else return 1 ; fi

#uninstall....
please_wait

if ! grep -q "fulcrum" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then
    set_terminal 
    echo "Fulcrum is not installed. You can skip uninstallation."
    enter_continue
    return 1 
    fi

log "fulcrum" "uninstall commenced"

if [[ $drive_fulcrum == "external" ]] ; then
    mount_drive || { set_terminal ; announce "drive needs to be mounted to remove fulcrum_db from drive. Proceed with caution." ; \
    enter_continue ; log "fulcrum" "drive not mounted, fulcrum_db  not deleted during uninstall." ; }
    rm -rf /media/$(whoami)/parmanode/fulcrum_db || debug "failed to delete fulcrum_db."
    fi
rm -rf /Volumes/parmanode/fulcrum_db >/dev/null 2>&1 

if [[ $drive_fulcrum == "internal" ]] ; then
    rm -rf $HOME/parmanode/fulcrum_db >/dev/null 2>&1 

    fi

rm -rf $HOME/parmanode/fulcrum >/dev/null 2>&1

stop_and_remove_docker_containers_and_images_fulcrum
parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"
log "fulcrum" "uninstall completed." 

success "Fulcrum" "being uninstalled"
return 0

}

function stop_and_remove_docker_containers_and_images_fulcrum {

docker stop fulcrum >/dev/null 2>&1 
docker rm fulcrum >/dev/null 2>&1 
docker rmi fulcrum >/dev/null 2>&1 

}