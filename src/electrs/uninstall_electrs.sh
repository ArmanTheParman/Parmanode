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
    echo -e "
########################################################################################

    A$pink backup$orange of electrs directory has been found in addition to the electrs
    installation. 
    
    Keeping it can save you time compiling it all again if you choose to re-install it.

    Remove that too? 

                                 y    or    n ?

######################################################################################## 
"
    read choice
    case $choice in
    y|Y) 
    please_wait ; rm -rf $HOME/.electrs_backup >/dev/null ; break ;;
    n|N) 
    please_wait ; break ;;
    *) invalid
    esac
done
fi

electrs_nginx remove
electrs_tor_remove

sudo systemctl stop electrs.service >/dev/null 2>&1
sudo systemctl disable electrs.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrs.service >/dev/null 2>&1

if [[ $drive_electrs == "external" && -e /media/$USER/parmanode/electrs_db ]] ; then
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
q|Q) 
quit 0 ;; 
p|P) 
return 1 ;;
d|D) 
sudo rm -rf /media/$USER/parmanode/electrs_db ; break ;;
l|L) 
break ;;
b|B) 
if [[ -d /media/$USER/parmanode/electrs_db_backup ]] ; then
    electrs_backup_exists #function defined below
    else
    sudo mv /media/$USER/parmanode/electrs_db /media/$USER/parmanode/electrs_db_backup
fi
break
;;
*) invalid ;;
esac
done
debug "electrs_db choice executed"
fi

rm -rf $HOME/parmanode/electrs && rm -rf $HOME/.electrs

parmanode_conf_remove "drive_electrs"
installed_config_remove "electrs" ; debug "end of uninstall"
success "electrs" "being uninstalled."
}

function electrs_backup_exists {
while true ; do
set_terminal "pink"
echo "
########################################################################################

    You have chosen to backup electrs_db to electrs_db_backup, but a directory
    with the name electrs_db_backup already exists. What would you like to do?

            d)    Delete the old backup directory and back up the current
                  electrs_db to electrs_db_backup
            
            2)    Move electrs_db_backup to electrs_db_backup2 and backup the 
                  electrs_db directory as electrs_db_backup - note parmanode is not 
                  configured to ever used the number 2 backup, you're on your own 
                  here with this fancy stuff, sorry.

            nah)  Changed my mind, delete the backups and the current electrs_db

########################################################################################
"
choose "xpq"
read choice
case $choice in q|Q) quit ;; p|P) return 1 ;;
d|D) rm -rf media/$USER/parmanode/electrs_db_backup ; break ;; 
2) 
mv media/$USER/parmanode/electrs_db_backup media/$USER/parmanode/electrs_db_backup2
mv media/$USER/parmanode/electrs_db /media/$USER/parmanode/electrs_db_backup 
;;
nah|Nah|NAH)
rm -rf /media/$USER/parmanode/electrs_db
rm -rf /media/$USER/parmanode/electrs_db_backup 
;;
*) invalid ;;
esac
done
}