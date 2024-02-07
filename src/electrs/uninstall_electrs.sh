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

# Uninstall binary backup

if [ -d $HOME/.electrs_backup ] ; then 
while true ; do
    set_terminal
    echo -e "
########################################################################################

    A$cyan backup$orange of electrs directory has been found in addition to the 
    current electrs installation (${cyan}$HOME/.electrs_backup$orange)
    
    Keeping the backup can save you time compiling it all again if you choose to 
    re-install electrs.

    REMOVE the backup too? 
$red
                        R)      Remove
$green                        
                        L)      Leave it
$orange
######################################################################################## 
"
    read choice
    set_terminal
    case $choice in
    R|r) 
    are_you_sure "Delete the previous compiled software? Not a great idea." || return 1
    please_wait ; rm -rf $HOME/.electrs_backup >/dev/null ; break ;;
    L|l) 
    please_wait ; break ;;
    *) invalid ;;
    esac
done
fi

electrs_nginx remove 

if [[ $OS == Linux ]] ; then electrs_tor_remove ; fi

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrs.service >/dev/null 2>&1
sudo systemctl disable electrs.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrs.service >/dev/null 2>&1
fi

# Uninstall - electrs_db

if [[ $drive_electrs == external ]] ; then export e_db="$parmanode_drive/electrs_db" ; fi
if [[ $drive_electrs == internal ]] ; then export e_db="$HOME/parmanode/electrs/electrs_db" ; fi
if [[ -e $e_db ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you want to delete the$cyan electrs_db database directory$orange, or leave it, or back
    it up as electrs_db_backup (remaining on the drive)?
$cyan
                          $e_db 

$red
                d)        Delete
$green
                l)        Leave it there
$white
                b)        Back it up 
$orange
########################################################################################
"
choose "xpmq"  
read choice
set_terminal
case $choice in
m|M) back2main ;;
q|Q) 
exit 0 ;; 
p|P) 
return 1 ;;
d|D) 
sudo rm -rf $e_db ; break ;;
l|L) 
break ;;
b|B) 
if [[ -d ${e_db}_backup ]] ; then
    electrs_backup_exists #function defined below
    else
    sudo mv $e_db ${e_db}_backup
    #if internal, moved to $HOME/parmanode/ later
fi
break
;;
*) invalid ;;
esac
done
debug "electrs_db choice executed"
fi

# Uninstall electrs github

mv $HOME/parmanode/electrs/electrs_db_backup* $HOME/parmanode/                        >/dev/null 2>&1
rm -rf $HOME/parmanode/electrs && rm -rf $HOME/.electrs                        >/dev/null 2>&1

parmanode_conf_remove "drive_electrs"
installed_config_remove "electrs-" 
success "electrs" "being uninstalled."
}
