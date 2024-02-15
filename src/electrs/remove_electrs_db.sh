function remove_electrs_db {
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
                delete)   Delete
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
delete) 
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
}