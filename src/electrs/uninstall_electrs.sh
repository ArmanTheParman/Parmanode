function uninstall_electrs {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall electrs 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done

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
                        l)         Leave it
$orange
######################################################################################## 
"
    read choice
    set_terminal
    case $choice in
    remove)
    are_you_sure "Delete the previous compiled software? Not a great idea." || return 1
    please_wait ; rm -rf $HOME/.electrs_backup >$dn ; break ;;
    L|l) 
    please_wait ; break ;;
    *) invalid ;;
    esac
done
fi

nginx_stream electrs remove

if [[ $OS == Linux ]] ; then electrs_tor_remove uninstall ; fi

if [[ $OS == Linux ]] ; then
sudo systemctl stop electrs.service >$dn 2>&1
sudo systemctl disable electrs.service >$dn 2>&1
sudo rm /etc/systemd/system/electrs.service >$dn 2>&1
fi

#asks for confirmation
remove_electrs_db 

# Uninstall electrs github
if [[ -e $hp/electrs/electrs_db ]] ; then
mv $HOME/parmanode/electrs/electrs_db_backup* $HOME/parmanode/    >$dn 2>&1
fi
sudo rm -rf $HOME/parmanode/electrs && sudo rm -rf $HOME/.electrs >$dn 2>&1
sudo systemctl stop socat.service >$dn 2>&1
sudo systemctl disable socat.service >$dn 2>&1
sudo rm -rf /etc/systemd/system/socat.service >$dn 2>&1
parmanode_conf_remove "electrs"
installed_config_remove "electrs-" 
success "electrs" "being uninstalled."
}
