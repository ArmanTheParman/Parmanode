function install_website {
return 0
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

website_intro || return 1

debug "after intro"

#Domain name questions
website_domain || return 1

debug "after domain"

website_update_system # runs apt-get

debug "after update"

install_certbot

debug "after certbot"

make_certbot_ssl

debug "after ssl make"

install_nginx

debug "after nginx"

install_MariaDB && installed_conf_add "website-start" # a MYSQL database

debug "after maridb and installed conf"

install_PHP 

debug "after php install"

make_website_directories # $hp/website - decided against user generated directory name

debug "after make dir"

download_wordpress #installs to new website directory

debug "after dl wordpress"

make_website_symlinks

debug "after symlinks"

#set permissions
sudo chown -R $USER:www-data /var/www/website
find /var/www/website -type d -exec chmod 755 {} \;
find /var/www/website -type f -exec chmod 644 {} \;
debug "after permissions"

#create database
create_website_database
debug "after create database"
mysql_security_wizard
debug "after security wizard"

installed_conf_add "website-end"
# FINISHED ########################################################################################
success "Your Website" "being configured"
########################################################################################
}


function phpmyadmin {
sudo apt-get install phpmyadmin -y

# Goes in nginx server conf ...

install_nginx #aborts if already installed.

echo "
server {
    listen 80;
    server_name your_server_domain_or_IP;  # Replace with your domain name or IP address
    
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
        }

        location ~* ^/phpmyadmin/(.+\.php)$ {
            try_files $uri =404;
            fastcgi_pass unix:/var/run/php/php7.x-fpm.sock; # Adjust based on your PHP version
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_index index.php;
        }

        location ~* ^/phpmyadmin/(.+\.(?:css|js|jpg|jpeg|gif|png|ico|svg|woff|woff2|ttf))$ {
            root /usr/share/;
        }
    }

    # Deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    location ~ /\.ht {
        deny all;
    }
}
          include /etc/nginx/fastcgi_params;
}
" | sudo tee /etc/nginx/conf.d    

sudo systemctl restart nginx
#Once everything is set up, you can access phpMyAdmin through your web browser by navigating to http://your_server_ip/phpmyadmin.

}


function make_website_directories {

if [[ ! -d $hp/website ]] ; then
mkdir $hp/website >/dev/null 2>&1
fi
}

function download_wordpress { 
cd $hp/website/ >/dev/null 2>&1
curl -LO https://wordpress.org/latest.zip
echo -e "$green Unzipping wordpress download...$orange" ; sleep 1
unzip *.zip && rm -rf *.zip
debug "wordpress downloaded and extracted to $hp/website/"
}

function website_update_system {

while true ; do
set_terminal ; echo -e "
########################################################################################
    Updating the OS with apt-get, OK?
$green
                              y)           Yes
$red 
                              n)           No

########################################################################################
" ; choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) quit 0 ;; n|N|NO|no|p|P) return 1 ;; y|Y) break ;; *) invlid ;; esac 
done

echo -e "$green Running apt-get update...$orange" ; sleep 1
sudo apt-get update -y
echo -e "green Running apt-get upgrade"
sudo apt-get upgrade -y
}

function install_MariaDB {
if grep "mariadb-end" < $ic >/dev/null 2>&1 ; return 0 ; fi
clear
echo -e "$green Installing php and MariaDB $orange" ; sleep 1
sudo apt-get -y --fix-broken --no-install-recommends install mariadb-server && installed_conf_add "mariadb-end" 
echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb
sudo systemctl start mariadb
}

function install_PHP {
if grep "php-end" <$ic >/dev/null 2>&1 ; return 0 ; fi
clear
sudo apt-get -y --fix-broken --no-install-recommends install php-cli phpmyadmin php-fpm php-mysql php-mbstring php-zip php-gd php-json \
php-curl php-xml php-intl php-bcmath php-imagick && installed_conf_add "php-end"
}

function mysql_security_wizard {
echo -e "$green Recommended MYSQL secure installtion settings ...$orange" ; sleep 1
echo ""
sudo mysql_secure_installation 
}

function make_website_symlinks {
if [[ ! -d /var/www/website ]] ; then
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi

if [[ ! -e $hp/website ]] ; then
sudo ln -s $hp/website /var/www/website || debug "failed symlink at /var/www/website"
fi
}

function install_phpmyadmin {
# will have pop ups user needs to respond to 
#sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
}

function create_website_database {
set_terminal

echo -e "
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

function install_certbot {
sudo apt-get -y --fix-broken --no-install-recommends install certbot python3-certbot-nginx -y
}


#function make_certbot_ssl