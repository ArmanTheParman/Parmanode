function create_website_database {
set_terminal ; echo -e "
########################################################################################
    Please choose a$cyan username$orange for your website's database. 
    It's best to not include any symbols.
########################################################################################

"
read username 
set_terminal

while true ; do
echo -e "
########################################################################################
    Please choose a$cyan password$orange for your website's database. 
    It's best to not include any symbols.
########################################################################################

"
read password ; set_terminal ; echo -e "
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

sudo mysql -u root -p
CREATE DATABASE website;
CREATE USER "$username"@'localhost' IDENTIFIED BY "$password";
GRANT ALL PRIVILEGES ON website.* TO "$username"@'localhost';
FLUSH PRIVILEGES;
EXIT;
}