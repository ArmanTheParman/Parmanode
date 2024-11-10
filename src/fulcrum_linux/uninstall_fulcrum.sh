function uninstall_fulcrum {

if [[ $OS == "Mac" ]] ; then
    uninstall_fulcrum_docker
    return 0
    fi

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Fulcrum 
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
                              delete)     Delete
$green
                              l)          Leave it
$orange
########################################################################################
"
choose "x" ; read choice
case $choice in
delete)
source $HOME/.parmanode/parmanode.conf >/dev/null 2>&1
if [[ $drive_fulcrum == "external" ]] ; then
    mount_drive || { set_terminal ; echo "drive needs to be mounted to remove fulcrum_db from drive. Proceed with caution." ; \
    enter_continue ; log "fulcrum" "drive not mounted, fulcrum_db  not deleted during uninstall." ; }
    rm -rf /media/$(whoami)/parmanode/fulcrum_db || debug "failed to delete fulcrum_db."
    fi

if [[ $drive_fulcrum == "internal" ]] ; then
    rm -rf $HOME/.fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db removed from int drive."
    #old location of internal db...
    rm -rf $HOME/parmanode/fulcrum_db >/dev/null 2>&1 && log "fulcrum" "fulcrum_db removed from int drive."
    fi
break
;;
l) break ;;
*) invalid ;;
esac
done

fulcrum_tor_remove
sudo rm -rf $HOME/parmanode/fulcrum >$dn 2>&1 
sudo rm -rf $HOME/.fulcrum >$dn 2>&1
sudo rm /usr/local/bin/Fulcrum* 2>$dn
sudo rm /etc/systemd/system/fulcrum.service 2>$dn

bitcoin_conf_remove 'zmqpubhashblock=tcp://0.0.0.0:8433'
parmanode_conf_remove "drive_fulcrum"
installed_config_remove "fulcrum"
success "Fulcrum" "being uninstalled"
}
