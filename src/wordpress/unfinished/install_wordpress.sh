function install_wordpress {
return 0
#still a work in progress.

#1 - Update system
#2 - Install Nginx
#3 - Install MariaDB & PHP

set_terminal

echo -e "$green Running apt update...$orange" ; sleep 1
sudo apt update -y

if ! which nginx >/dev/null ; then
echo -e "$green Installing Nginx ...$orange" ; sleep 1
install_nginx
fi

echo -e "$green Installing php and MariaDB and other stuff ...$orange" ; sleep 1
sudo apt-get install mariadb-server -y
sudo apt install php-cli phpmyadmin php-fpm php-mysql php-mbstring php-zip php-gd php-json \
php-curl php-xml php-intl php-bcmath php-imagick -y



echo -e "$green Recommended MYSQL secure installtion settings ...$orange" ; sleep 1
sudo mysql_secure_installation 

echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo -e "$green Setting up directory structure...$orange" ; sleep 1
cd $hp

if [[ -e $hp/wordpress ]] ; then
wordpress_exists
fi

mkdir wordpresstemp
cd wordpresstemp
curl -LO https://wordpress.org/latest.zip
echo -e "$green Unzipping wordpress download...$orange"
unzip *.zip
rm -rf *.zip
mv wordpress ..
cd $hp
rm -rf wordpresstemp
cd wordpress

########################################################################################

sudo ln -s /usr/share/phpmyadmin /var/www/html

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

function install_phpmyadmin {
# will have pop ups user needs to respond to 
#sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
}

