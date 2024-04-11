function backup_website_database {
while true ; do
set_terminal ; echo -e "
########################################################################################

   Parmanode will backup the database to a file called$cayn website_database.sql$orange and leave
   it on the Desktop. You can change the filename after that if you want. 
   
   Make sure such a file doesn't exist there already (previous database) or it will be
   overwritten without prompting.

   You will be prompted for the database user's password which you created when
   first setting up the database/website.

########################################################################################
"
choose "epmq" ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

"")

mysqldump -u parmanode -p website > $HOME/Desktop/website_database.sql 2>&1 

if head -n1 $HOME/Desktop/website_database.sql | grep -q error ; then

error_text=$(head -n1 $HOME/Desktop/website_database.sql)

announce "There was an error; you  might have put the wrong password in. Remember,
    you need to put the database password, not your computer password. Could be
    that.

    Error:
$red
    $error_text $orange
"
rm $HOME/Desktop/website_database.sql >/dev/null 2>&1
return 1
fi


break
;;
*)
invalid 
;;
esac
done
}

