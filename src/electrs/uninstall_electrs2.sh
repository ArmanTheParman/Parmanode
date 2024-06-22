function uninstall_electrs2 {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall electrs 
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
                        remove)    Remove
$green                        
                        L)         Leave it
$orange
######################################################################################## 
"
    read choice
    set_terminal
    case $choice in
    remove)
    are_you_sure "Delete the previous compiled software? Not a great idea." || return 1
    please_wait ; rm -rf $HOME/.electrs_backup >/dev/null ; break ;;
    L|l) 
    please_wait ; break ;;
    *) invalid ;;
    esac
done
fi

nginx_stream electrs remove

if [[ $OS == Linux ]] ; then electrs_tor_remove uninstall ; fi

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrs.service >/dev/null 2>&1
sudo systemctl disable electrs.service >/dev/null 2>&1
sudo rm /etc/systemd/system/electrs.service >/dev/null 2>&1
fi

#asks for confirmation
remove_electrs_db 

# Uninstall electrs github
if [[ -e $hp/electrs/electrs_db ]] ; then
mv $HOME/parmanode/electrs/electrs_db_backup* $HOME/parmanode/                        >/dev/null 2>&1
fi
rm -rf $HOME/parmanode/electrs && rm -rf $HOME/.electrs                        >/dev/null 2>&1
sudo rm -rf /etc/systemd/socat_listen* /etc/systemd/socat_publish* >/dev/null 2>&1
rm $dp/*socat_electrs.sh >/dev/null
parmanode_conf_remove "drive_electrs"
installed_config_remove "electrs2-" 
success "electrs" "being uninstalled."
}
