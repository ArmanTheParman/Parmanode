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
choose "xpmq"
read choice
case $choice in q|Q) exit ;; p|P) return 1 ;;
m) back2main ;;
d|D) rm -rf ${e_db}_backup ; break ;; 
2) 
mv ${e_db}_backup ${e_db}_backup2
mv  ${e_db} ${e_db}_backup
;;
nah|Nah|NAH)
rm -rf $e_db
rm -rf ${e_db}_backup
;;
*) invalid ;;
esac
done
}