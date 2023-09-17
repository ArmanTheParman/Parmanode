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
    installation. 
    
    Keeping it can save you time compiling it all again if you choose to re-install it.

    Remove that too? 

                                 y    or    n ?

######################################################################################## 
"
    read choice
    case $choice in
    y|Y) please_wait ; rm -rf $HOME/.electrs_backup >/dev/null ;;
    n|N) please_wait ; break ;;
    *) invalid
    esac
done
fi


electrs_nginx remove
electrs_tor_remove

sudo systemctl stop electrs.service >/dev/null
sudo systemctl disable electrs.service >/dev/null
sudo rm /etc/systemd/system/electrs.service >/dev/null

if [[ $drive_electrs == "external" ]] ; then
while true ; do
set_terminal "pink" ; echo "
########################################################################################

    Do you want to delete the electrs_db database directory, or leave it, or back
    it up as electrs_db_backup (remaining on the drive)?

                d)        Delete

                l)        Leave it there

                b)        Back it up (just renames it)

########################################################################################
"
choose "xpq"  
read choice
set_terminal
case $choice in
q|Q) quit 0 ;; p|P) return 1 ;;
d|D) sudo rm -rf /media/$USER/parmanode/electrs_db ; break ;;
l|L) break ;;
b|B) sudo mv /media/$USER/parmanode/electrs_db /media/$USER/parmanode/electrs_db_backup ; break ;;
*) invalid ;;
esac
done
debug "electrs_db choice executed"
fi

rm -rf $HOME/parmanode/electrs

parmanode_conf_remove "drive_electrs"
installed_config_remove "electrs" ; debug "end of uninstall"
success "electrs" "being uninstalled."
}