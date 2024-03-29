# get it working first, http only, configure nginx
# then later get user to open port 80 and 443 and to ssl cert + challenge

function install_website {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi

website_intro || return 1

#Domain name questions
website_domain || return 1

debug "after domain"

website_update_system # runs apt-get

debug "after update"

if [[ -e /var/www/website ]] ; then
announce "
    A website already exists at /var/www/website. Please delete it or move it and
    try again. Aborting."
return 1
fi

install_certbot

install_expect # needed for non interactive wizard later

debug "after certbot"

#In case nginx already isntalled...
#remove_nginx_sites_enabled || return 1

#can now check ports? #or, check if nginx is freshly installed.
website_check_ports || return 1 #if port 80 or 443 in use and not by nginx, then abort.

#if which nginx >/dev/null 2>&1 ; then nginx_preexists=true ; else nginx_preexists=false ; fi
install_nginx 

#if [[ $nginx_preexists == false ]] ; then
#remove_nginx_sites_enabled silent  
#fi

debug "after nginx"

install_MariaDB && installed_conf_add "website-start" # a MYSQL database

debug "after maridb and installed conf"

install_PHP 

debug "after php install"

make_website_directories # $hp/website - decided against user generated directory name

debug "after make dir"

download_wordpress #installs to new website directory
debug "after dl wordpress"

#make php info page
echo "<?php phpinfo(); ?>" | sudo tee /var/www/website/info.php >/dev/null 2>&1

#set permissions
sudo chown -R www-data:www-data /var/www/website
sudo find /var/www/website -type d -exec chmod 755 {} \; >/dev/null 2>&2
sudo find /var/www/website -type f -exec chmod 644 {} \; >/dev/null 2>&2
debug "after permissions"

mysql_security_wizard || debug "failed after security wizard"

#create database
create_website_database || debug "failed - after create database"

#make_certbot_ssl #not finished

make_website_nginx && sudo systemctl restart nginx >/dev/null 2>&1

installed_conf_add "website-end"

success "Your Website has finished being configured.

    To set up WordPress, go to $cyan$domain/myphpadmin$orange
    and fill in the details requested. You'll need the database name (\"website\") and
    the username ($username) and password you chose during this installation. If 
    you forgot the password, it's been stored in
$cyan
    $pc$orange
"
}


function make_website_directories {
if [[ ! -d /var/www/website ]] ; then
set_terminal
sudo mkdir -p /var/www/website >/dev/null 2>&1
fi
}

function mysql_security_wizard {
#run wizard with expect script...
please_wait
sudo $pp/parmanode/src/website/wont_source/website_expect_wizard.sh 
}


function install_certbot {
sudo apt-get -y --fix-broken --no-install-recommends install certbot python3-certbot-nginx -y
}

#function make_certbot_ssl #need domain name variable before doing this.

function install_expect {
sudo apt-get -y --fix-broken --no-install-recommends install expect
}