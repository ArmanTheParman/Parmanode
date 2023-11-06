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
please_wait
rm -rf $hp/electrs/electrs_db
mv $hp/electrs_db_backup $hp/electrs/
mv $hp/electrs/electrs_db_backup $hp/electrs/electrs_db
return 0
;;
*) invalid ;;
esac
done

}