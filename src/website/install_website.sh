# get it working first, http only, configure nginx, then get user
# to open port 80 and 443 and to ssl cert + challenge

function install_website {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

website_intro || return 1

#Domain name questions
website_domain || return 1

debug "after domain"

website_update_system # runs apt-get

debug "after update"

install_certbot
install_expect # needed for non interactive wizard later

debug "after certbot"

#In case nginx already isntalled...
remove_nginx_sites_enabled || return 1

#can now check ports? #or, check if nginx is freshly installed.
check_ports_website || return 1 #if port 80 or 443 in use, then abort.

if which nginx >/dev/null 2>&1 ; then nginx_preexists=true ; else nginx_preexists=false ; fi
install_nginx 

if [[ $nginx_preexists == false ]] ; then
remove_nginx_sites_enabled silent  
fi

debug "after nginx"

install_MariaDB && installed_conf_add "website-start" # a MYSQL database

debug "after maridb and installed conf"

install_PHP 

debug "after php install"

make_website_directories # $hp/website - decided against user generated directory name

debug "after make dir"

download_wordpress #installs to new website directory

debug "after dl wordpress"

make_website_symlinks #may be redundant

debug "after symlinks"

#set permissions
sudo chown -R $USER:www-data /var/www/website
find $hp/website -type d -exec chmod 755 {} \;
find $hp/website -type f -exec chmod 644 {} \;
debug "after permissions"

mysql_security_wizard || debug "failed after security wizard"

#create database
create_website_database || debug "failed - after create database"

#make_certbot_ssl #not finished

installed_conf_add "website-end"
# FINISHED ########################################################################################
success "Your Website" "being configured"
########################################################################################
}


function phpmyadmin {

#redundant...
#sudo apt-get install phpmyadmin -y

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
if [[ ! -d /var/www/website ]] ; then
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi

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
$orange
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
if ! which mariadb >/dev/null 2>&1 ; then return 0 ; fi
clear
echo -e "$green Installing php and MariaDB $orange" ; sleep 1
sudo apt-get -y --fix-broken --no-install-recommends install mariadb-server 
echo -e "$green Enabling autostart on bootup ...$orange" ; sleep 1
sudo systemctl enable mariadb >/dev/null
sudo systemctl start mariadb >/dev/null
}

function install_PHP {
set_terminal ; echo -e "
########################################################################################
    Parmanode will install phpMyAdmin, and some other php tools. You might be asked
    during the installation about auto configuration for a web server, with the 
    choices:

        Apache2
        Lighttpd
$cyan
    It won't matter which you choose$orange, Parmanode will configure phpMyAdmin with Nginx
    instead. Just randomly choose one and carry on.

    You will also be shown a second screen which offers to configure a database.
$pink
    Decline this option by choosing <No> !
$orange
########################################################################################
"
enter_continue
sudo apt-get -y --fix-broken --no-install-recommends install php-cli phpmyadmin php-fpm php-mysql php-mbstring php-zip php-gd php-json \
php-curl php-xml php-intl php-bcmath php-imagick || debug "failed apt-get install php command"
}

function mysql_security_wizard {
#run wizard with expect script...
sudo $pp/parmanode/src/website/wont_source/website_expect_wizrd.sh >/dev/null
}

function make_website_symlinks {
#might be redundant, but just in case some other peoples' code points to the /var/www/ location
sudo ln -s $hp/website /var/www/website || debug "failed symlink at /var/www/website"
}

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

function install_certbot {
sudo apt-get -y --fix-broken --no-install-recommends install certbot python3-certbot-nginx -y
}


#function make_certbot_ssl #need domain name variable before doing this.

function check_ports_website {

if sudo netstat -tulnp | grep -q :80  ; then
echo -e "
########################################################################################
    
    It looks like port 80 is already being used by this computer. This port is the 
    standard port for TCP internet traffic.

    Parmanode is not smart enough, yet, to install a website on funky ports. Aborting.

########################################################################################
" 
enter_continue
return 1
fi
if sudo netstat -tulnp | grep -q :443  ; then
echo -e "
########################################################################################
    
    It looks like port 443 is already being used by this computer. This port is the 
    standard port for SSL internet traffic.

    Parmanode is not smart enough, yet, to install a website on funky ports. Aborting.

########################################################################################
" 
enter_continue
return 1
fi
}

function remove_nginx_sites_enabled {

if [[ ! -e /etc/nginx/sites-enabled/default ]] ; then return 0 ; fi

if [[ $1 != silent ]] ; then

while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode will remove the default server for nginx (the one that automatically is
    configured when nginx is installed).

    If this is meaningless to you, great, hit$cyan <enter>$orange to continue and 
    Parmanode will delete it; it's not needed.

    If you do run a server with Nginx already, then this installation is not for you. 
    You should hit$red a$orange and$cyan <enter>$orange to abort, otherwise Parmanode might 
    delete your server configuration.

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P|A|a) return 1 ;; "") break ;; *) invalid ;; 
esac
done
sudo rm /etc/nginx/sites-enabled/default
return 0
else #silent removal because nginx just installed, no risk of removing wanted configuration files
sudo rm/etc/nginx/sites-enabled/default >/dev/null 2>&1
fi
}

function install_expect {
sudo apt-get -y --fix-broken --no-install-recommends install expect
}