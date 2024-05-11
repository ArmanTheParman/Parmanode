function restore_website_database {

while true ; do
set_terminal ; echo -e "
########################################################################################

   Parmanode will restore your database to a file; you have to type in the full path
   to the file you want to restore.
   
   If you import a database that was not backed up by Parmanode, that is, if it's a
   foreign database with unanticipated settings, you might need do do some manuel 
   tweaking to get it to work with usernames and passwords and priviledges etc.
$cyan
   Please type in the full path of the file you want to import and hit <enter>:
$orange
########################################################################################
"
choose "epmq" ; read databasefile ; set_terminal
case $databasefile in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;
*)
echo -e "
########################################################################################

    You entered:
$cyan
    $choice $orange

    Is this correct? (y/n)

########################################################################################
"
read choice2 ; case $choice in y) break ;; *) continue ;; esac
set_terminal
;;
esac
done
#check details of database to be imported...
database_name=$(cat "$databasefile" | grep Database: | head -n1 | cut -d : -f 3 | awk '{$1=$1;print}')

if [[ $database_name != "website" ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you are importing a custom named database (It was
    expecting a database called 'website' but got $database_name instead). This is
    totallty fine, just be aware that the database needs to exist (even if empty) and
    must have the same name, and the 'parmanode' user must have acces to it, for it 
    to import successfully.

########################################################################################
"
choose "eq" ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; "") break ;; *) invalid ;;
esac
done

else # database to be imported must be called 'website'

while true ; do
set_terminal ; echo -e "
########################################################################################

    If you import the website database, any existing data in the 'website' database
    will be MERGED.

    You have choices... $cyan

        1)    Continue and let the merge happen 

        2)    Abort, so you can delete and recreate a blank database first, 
              then you'll come back.

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P|2) return 1 ;; 1) break ;; m|M) back2main ;; *) invalid ;;
esac
done
fi

if ! sudo mysql -u root -p -e "SHOW DATABASES LIKE '$database_name';" | grep -q "$database_name"; then
set_terminal ; echo -e "
########################################################################################

    The database $database_name does not exist in the destination. You must 
    first create the database to allow an import/merge.

########################################################################################
"
enter_continue
return 1
fi
#import database...
mysql -u parmanode -p $database_name < $databasefile 
return 0
}