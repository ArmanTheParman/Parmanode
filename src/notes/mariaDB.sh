return 0
# MariaDB credentials
set_terminal
echo -e "
########################################################################################

    Please enter a MariaDB username

########################################################################################
"
read MARIADB_USER

while true ; do
set_terminal
echo -e "
########################################################################################

    Please enter a MariaDB password

########################################################################################
"
read MARIADB_PASS
set_terminal
echo -e "
########################################################################################

    Please repeat the password

########################################################################################
"
read repeat
if [[ $repeat == $MARIADB_PASS ]] ; then break ; else
set_terminal
echo -e "
########################################################################################

    Passwords don't match, please try again. Hit <enter> first ...

########################################################################################
"
read
continue
fi
done

# Database and user information for WordPress
WP_DB_NAME="wordpress_db"         # Change this to your desired database name
WP_USER="wordpress_user"          # Change this to your desired WordPress user
WP_PASS="wordpress_user_password" # Change this to your desired WordPress user password

# Connect to MariaDB and run the setup commands
mysql -u"$MARIADB_USER" -p"$MARIADB_PASS" <<EOF
CREATE DATABASE $WP_DB_NAME;
CREATE USER '$WP_USER'@'localhost' IDENTIFIED BY '$WP_PASS';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

echo "Database and user setup complete."

