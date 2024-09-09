function create_website_database {
set_terminal 
while true ; do
set_terminal ; echo -e "
########################################################################################

    MariaDB is the database that will hold your website's data. The database will be
    called '$website'.

    A username for the database will be created, called 'parmanode'.

    Please choose a$cyan password$orange for this user to access your website. BTW, it 
    will be stored in the parmanode.conf file.

    It's best to not include any symbols.
    $pink
    NOTE YOU WILL NEED TO ENTER IT 3 TIMES. ONCE TO DECLARE IT, ANOTHER TO CONFIRM,
    AND FILNALLY AGAIN TO USE IT TO CREATE THE DATABASE.$orange

########################################################################################

"
read password ; set_terminal ; if [[ -z $password ]] ; then announce "Password can not be empty" ; continue ; fi
set_terminal ; echo -e "
########################################################################################
    Please repeat the$cyan password${orange}.
########################################################################################

"
read password2 ; set_terminal
if [[ $password != $password2 ]] ; then
echo -e "Passwords don't match. Hit$cyan <enter>$orange to try again."
continue
fi    
break
done
parmanode_conf_add "${website}_database_user=parmanode"
parmanode_conf_add "${website}_database_password=$password"
sudo mysql -u root -p -e "CREATE DATABASE $website; CREATE USER \"parmanode\"@'localhost' IDENTIFIED BY \"$password\"; GRANT ALL PRIVILEGES ON $website.* TO \"parmanode\"@\"localhost\"; FLUSH PRIVILEGES;"
}
