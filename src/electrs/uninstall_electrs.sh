function uninstall_electrs {

set_terminal ; echo "
########################################################################################

                                 Uninstall electrs 

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

source $HOME/.parmanode/parmanode.conf

if [ -d $HOME/.electrs_backup ] ; then 

while true ; do
    set_terminal
    echo "
########################################################################################

    A backup of electrs directory has been found in addition to the electrs
    installation. Remove that too?    
    
                                 y    or    n ?

######################################################################################## 
"
    read choice
    case $choice in
    y|Y) rm -rf $HOME/.electrs_backup >/dev/null ;;
    n|N) break ;;
    *) invalid
    esac
done
fi


electrs_nginx remove

parmanode_conf_remove "electrs"

sudo systemctl stop electrs.service >/dev/null
sudo systemctl disable electrs.service >/dev/null
sudo rm /etc/systemd/system/electrs.service >/dev/null

if [[ $drive_electrs == "external" ]] ; then
sudo rm -rf /media/$USER/parmanode/electrs_db >/dev/null
fi

rm -rf $HOME/parmanode/electrs

parmanode_conf_remove "electrs"
installed_config_remove "electrs" ; debug "end of uninstall"
}