function install_website {
return 0
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

set_terminal

website_update_system
install_nginx
install_MariaDB 
install_PHP 
mysql_security_wizard
make_website_directories #user names the directory
download_wordpress #installs to new website directory
make_website_symlinks
#set permissions
#create database

# FINISHED ########################################################################################
success "Your Website" "being configured"
########################################################################################




# Goes in nginx server conf ...

location /phpmyadmin {
    root /usr/share/;
    index index.php index.html index.htm;
    location ~ ^/phpmyadmin/(.+\.php)$ {
        try_files $uri =404;
        root /usr/share/;
        fastcgi_pass unix:/var/run/php/php7.x-fpm.sock; # Adjust the PHP version
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include /etc/nginx/fastcgi_params;

sudo systemctl restart nginx
#Once everything is set up, you can access phpMyAdmin through your web browser by navigating to http://your_server_ip/phpmyadmin.


}


function make_website_directories {

while true ; do
set_terminal ; echo -e "
########################################################################################
    
    What name would you like to give to the directory that keeps your website's 
    files?$cyan This is NOT the title of your website$orange and only you'll see it
    in your directory structure as...
$green
            $hp/parmanode/websites/my_website_example   
$orange
    Go ahead and type the name of the directory at the prompt, then hit$cyan <enter>$orange
$pink
    Use only lowercase letters and no spaces.
$orange
########################################################################################
"
read websitename 
if
if [[ ! $websitename =~ ^[a-z]+$ ]]; then
clear 
echo "Name should inlcude only characters a to z. Please try again."
continue
else
    if [[ ${#websitename} -gt 19 ]] ; then
    clear
    echo "Please keep the length below 20 characters"
    continue
    fi
break
fi
done

export websitename
echo "$websitename" >> $dp/websites.conf 
export websitedir="$hp/websites/$websitename"
mkdir -p $websitedir

}

function download_wordpress { 
cd $websitedir
curl -LO https://wordpress.org/latest.zip
echo -e "$green Unzipping wordpress download...$orange" ; sleep 1
unzip *.zip && rm -rf *.zip
debug "wordpress downloaded and extracted to $websitedir"
}

function website_update_system {
echo -e "$green Running apt update...$orange" ; sleep 1
sudo apt update -y
}

function install_MariaDB {
if grep "mariadb-end" < $ic >/dev/null 2>&1 ; return 1 ; fi
clear
echo -e "$green Installing php and MariaDB $orange" ; sleep 1
sudo apt-get install mariadb-server -y && installed_conf_add "mariadb-end" 
echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb
sudo systemctl start mariadb
}

function install_PHP {
if grep "php-end" <$ic >/dev/null 2>&1 ; return 1 ; fi
clear
sudo apt install php-cli phpmyadmin php-fpm php-mysql php-mbstring php-zip php-gd php-json \
php-curl php-xml php-intl php-bcmath php-imagick -y && installed_conf_add "php-end"
}

function mysql_security_wizard {
echo -e "$green Recommended MYSQL secure installtion settings ...$orange" ; sleep 1
sudo mysql_secure_installation 
}

function make_website_symlinks {
if [[ ! -d /var/www ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode is expecting the directory$cyan /var/www/ to exist$orange.

    I don't know why it wouldn't be there - Nginx should have made it if it doesn't
    exist. Parmanode WAS going to place a symlink with your website directory's
    name at /var/www, like this:$cyan /var/www/$websitename

    You have options:
$green
                       a)       Abort and try to fix this
$red
                       yolo)    Whatever, keep going with the install
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m|a|A) back2main ;;
yolo)
break ;;
*)
invalid ;;
esac
done
sudo ln -s $websitedir /var/www/$websitename || debug "failed symlink at /var/www/$websitename"
}

function install_phpmyadmin {
# will have pop ups user needs to respond to 
#sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
}

