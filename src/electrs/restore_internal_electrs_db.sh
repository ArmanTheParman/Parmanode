function restore_internal_electrs_db {

if [[ ! -e $hp/electrs_db_backup ]] ; then return 0 ; fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Would you like to use the backup data directory... 

    $hp/electrs_db_backup ?

    y) yes please that's outrageously good

    n) nah, leave it

    d) nah, and get rid of it

########################################################################################
"
choose "xpq" ; read choice
case $choice in
q|Q) quit ;;
p|P) return 1 ;;
n|N|nah) return 0 ;;
d|D|delete) 
please_wait 
rm -rf $hp/electrs_db_backup
return 0
;;
y|Y|YES|Yes|yes)
please_wait
mv $hp/electrs_db_backup $hp/electrs/electrs_db
;;
*) invalid ;;
esac
done

}