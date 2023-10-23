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

    A$pink backup$orange of electrs directory has been found in addition to the 
    current electrs installation (${pink}$HOME/.electrs_backup$orange)
    
    Keeping the backup can save you time compiling it all again if you choose to 
    re-install electrs.
$pink 
    Remove$orange the backup too? 

                                 y    or    n  ?

######################################################################################## 
"
    read choice
    set_terminal
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
sudo rm -rf $e_db ; break ;;
l|L) 
break ;;
b|B) 
if [[ -d ${e_db}_backup ]] ; then
    electrs_backup_exists #function defined below
    else
    sudo mv $e_db ${e_db}_backup
fi
break
;;
*) invalid ;;
esac
done
debug "electrs_db choice executed"
fi

# Uninstall electrs github

mv $HOME/parmanode/electrs/electrs_db* $HOME/parmanode/                        >/dev/null 2>&1
rm -rf $HOME/parmanode/electrs && rm -rf $HOME/.electrs                        >/dev/null 2>&1

parmanode_conf_remove "drive_electrs"
installed_config_remove "electrs" 
success "electrs" "being uninstalled."
}
