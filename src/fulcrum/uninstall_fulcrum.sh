function uninstall_fulcrum {

while true
do
set_terminal ; echo "
########################################################################################

                            Fulcrum will be uninstalled

########################################################################################
"
choose "epq" ; read choice
case $choice in 

     q|Q|Quit|QUIT) exit 1 ;; p|P) return 1 ;;
     
    "") break ;;

    *) Invalid ;;

    esac
done    

if ! grep "fulcrum-start" $HOME/.parmanode/installed.conf ; then 
    set_terminal ; echo "
Fulcrum is not installed. No need to uninstall. Exiting. 
" && enter_continue && return 1
fi

log "fulcrum" "uninstall commenced"
parmanode_conf_remove "fulcrum"


if [[ $fulcrum_drive == "external" ]] ; then
    mount_drive || { set_terminal ; echo "drive needs to be mounted to remove fulcrum_db from drive. Proceed with caution." ; \
    enter_continue ; log "fulcrum" "drive not mounted, fulcrum_db  not deleted during uninstall." ; }
    case $OS in
    Mac) rm -rf /Volumes/parmanode/fulcrum_db ;;
    Linux) rm -rf /media/$(whoami)/parmanode/fulcrum_db ;;
    esac
    fi

if [[ $fulcrum_drive == "internal" ]] ; then
    rm -rf $HOME/parmanode/fulcrum_db
    fi

rm -rf $HOME/parmanode/fulcrum

sudo rm /usr/local/bin/Fulcrum*
sudo rm /etc/systemd/system/fulcrum.service

installed_config_removed "fulcrum"
log "fulcrum" "uninstall completed" && return 0
}