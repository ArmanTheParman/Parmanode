function uninstall_fulcrum_docker {
while true ; do
echo "
########################################################################################

    This will uninstall Fulcrum only. If you want to uninstall Docker as well, you 
    can do that afterwards from within the Docker application.

########################################################################################        
"
choose "epq" ; read choice
case $choice in q|Q|QUIT|Quit) exit 0 ;; p|P) return 1 ;; 
"") break ;;
*) invalid ;; esac ; done 

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
    mount_drive || { set_terminal ; echo "drive needs to be mounted to remove fulcrum_db from drive. Proceed with caution." ; \
    enter_continue ; log "fulcrum" "drive not mounted, fulcrum_db  not deleted during uninstall." ; }
    rm -rf /media/$(whoami)/parmanode/fulcrum_db || debug "failed to delete fulcrum_db."
    fi
rm -rf /Volumes/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db removed from ext drive."

if [[ $drive_fulcrum == "internal" ]] ; then
    rm -rf $HOME/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db removed from int drive."

    fi

rm -rf $HOME/parmanode/fulcrum >/dev/null 2>&1 && log "fulcrum" "parmanode/fulcrum direcctory removed from int drive."


stop_and_remove_docker_containers_and_images_fulcrum

parmanode_conf_remove "fulcrum"
installed_config_remove "fulcrum"

log "fulcrum" "uninstall completed." && { set_terminal ; echo "Fulcrum has been uninstalled." ; enter_continue ; return 0 ; }

return 0

}



function stop_and_remove_docker_containers_and_images_fulcrum {

docker stop fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum container stopped"
docker rm fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum container deleted"
docker rmi fulcrum >/dev/null 2>&1 && log "fulcrum" "fulcrum image deleted "

}