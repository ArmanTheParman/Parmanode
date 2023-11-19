function uninstall_fulcrum {

if [[ $OS == "Mac" ]] ; then
    uninstall_fulcrum_docker
    return 0
    fi

set_terminal ; echo "
########################################################################################

                                 Uninstall Fulcrum 

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

if ! grep "fulcrum-start" $HOME/.parmanode/installed.conf >/dev/null 2>&1 ; then 
    set_terminal ; echo "
Fulcrum is not installed. No need to uninstall. Exiting. 
" && enter_continue && return 1
fi

while true ; do
set_terminal ; echo -e "
########################################################################################

                What shall be done with the Fulcrum Database?
$red
                              d)     Delete
$green
                              l)     Leave it
$orange
########################################################################################
"
choose "x" ; read choice
case $choice in
d)
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ $drive_fulcrum == "external" ]] ; then
    mount_drive || { set_terminal ; echo "drive needs to be mounted to remove fulcrum_db from drive. Proceed with caution." ; \
    enter_continue ; log "fulcrum" "drive not mounted, fulcrum_db  not deleted during uninstall." ; }
    rm -rf /media/$(whoami)/parmanode/fulcrum_db || debug "failed to delete fulcrum_db."
    fi

if [[ $drive_fulcrum == "internal" ]] ; then
    rm -rf $HOME/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db removed from int drive."
    fi
;;
l) break ;;
*) invalid ;;
esac
done

fulcrum_tor_remove

rm -rf $HOME/parmanode/fulcrum >/dev/null 2>&1 && log "fulcrum" "parmanode/fulcrum direcctory removed from int drive."

sudo rm /usr/local/bin/Fulcrum* 2>/dev/null && log "fulcrum" "Fulcrum binary deleted from /usr/local/bin."
sudo rm /etc/systemd/system/fulcrum.service 2>/dev/null && log "fulcrum" "service file deteleted."

parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"
log "fulcrum" "uninstall completed." && { set_terminal ; echo "Fulcrum has been uninstalled." ; enter_continue ; return 0 ; }
}