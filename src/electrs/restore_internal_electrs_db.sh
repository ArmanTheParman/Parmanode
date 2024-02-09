function restore_internal_electrs_db {

if [[ ! -e $hp/electrs_db_backup ]] ; then return 0 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like to use the backup data directory... 

                 $hp/electrs_db_backup ?


$red       y)$orange  Yes please that's outrageously good

$red       n)$orange  Nah, leave it

$red       d)$orange  Nah, and get rid of it

########################################################################################
"
choose "xpmq" ; read choice
case $choice in

m|M) back2main ;;
q|Q) exit ;;
p|P) return 1 ;;
n|N|nah) return 0 ;;
d|D|delete) 
please_wait 
rm -rf $hp/electrs_db_backup
return 0
;;
y|Y|YES|Yes|yes)
if [[ -d $HOME/.electrs_db ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################
    Parmanode was about to move the backed up database directory to  $cyan
    $HOME/.electrs_db$orange but that directory already exists.

     a)    Abort, Abort ! 

     b)    Do it anyway, I don't care if I lose what's in $HOME/lelectrs_db
    
     c)    Abandon the move and just use whats in $HOME/.electrs_db

########################################################################################    
" ; choose "xpmq" ; read choice ; clear
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M|a) back2main ;;
b)
please_wait
rm -rf $hp/electrs/electrs_db #remnant after refactoring, delete later.
rm -rf $HOME/.electrs_db
mv $hp/electrs_db_backup $HOME/.electrs_db 
return 0
;;
c)
return 0
;;
*) invalid ;;
esac
done
else
mv $hp/electrs/electrs_db $HOME/
fi
;;

*) invalid ;;
esac
done

}