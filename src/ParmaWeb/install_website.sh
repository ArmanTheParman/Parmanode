function install_website {

website_intro || return 1

no_mac || { announce "If there is demand for Macs, it's up to you to let me know and I'll get on to it." ; return 1 ; }

choose_database_name || return 1

if [[ -e /var/www/$website ]] ; then
announce "
    The directory /var/www/$website already exits. Please delete or move it or move 
    it and try again. Aborting."
return 1
fi

#Domain name questions
website_domain || return 1
website_update_system # runs apt-get


website_check_ports || return 1 #if port 80 or 443 in use and not by nginx, then abort.

website_dependencies && installed_conf_add "website-start" 
debug "after website dependencies" 

make_website_directories 
debug "after make dir"

download_wordpress #installs to new website directory
debug "after download wordpress"

#make php info page
echo "<?php phpinfo(); ?>" | sudo tee /var/www/$website/info.php >/dev/null 2>&1

#set permissions
sudo chown -R www-data:www-data /var/www/$website
sudo find /var/www/$website -type d -exec chmod 755 {} \; >/dev/null 2>&2
sudo find /var/www/$website -type f -exec chmod 644 {} \; >/dev/null 2>&2
debug "after permissions"

mysql_security_wizard || debug "failed after security wizard"

#create database
create_website_database || debug "failed - after create database"

make_website_nginx && sudo systemctl restart nginx >/dev/null 2>&1

installed_conf_add "website-end"

success "Your Website has finished being configured.

    To set up WordPress go to the Parmanode Website menu.

    From there you can configure your site.
"
}
