function uninstall_electrs_docker {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                            Uninstall electrs (Docker)
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) backtomain ;;
y) break ;;
n) return 1 ;;
*) invalid ;;
esac
done
if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

source $pc

if [[ $OS == Linux ]] ; then electrs_tor_remove uninstall ; fi

docker stop electrs
docker rm electrs
docker rmi electrs

# Uninstall - electrs_db

if [[ $drive_electrs == external ]] ; then export e_db="$parmanode_drive/electrs_db" ; fi
if [[ $drive_electrs == internal ]] ; then export e_db="$HOME/.electrs_db" ; fi
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
fi

# Uninstall electrs github

if [[ -e $hp/electrs/electrs_db ]] ; then
mv $HOME/parmanode/electrs/electrs_db_backup* $HOME/parmanode/ $dn 2>&1
fi

sudo rm -rf $HOME/parmanode/electrs && sudo rm -rf $HOME/.electrs $dn 2>&1

sudo rm $dp/*socat_electrs.sh >$dn
parmanode_conf_remove "drive_electrs"
installed_config_remove "electrsdkr" 
success "electrs" "being uninstalled."
}
