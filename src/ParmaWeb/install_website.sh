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

function choose_database_name {

while true ; do
set_terminal ; echo -e "
########################################################################################

    The default name for the database and directory where information about the
    website is stored is called 'website'. This may be a problem for people tinkering
    and installing more than one site on the same computer. In that case you can
    choose one of the following names - Parmanode will check they don't already
    exists.

                        d)       website      $green(default) $orange
                        2)       website2
                        3)       website3
                        4)       website4
                        5)       website5
                        6)       website6
                        7)       website7
                        8)       website8
                        9)       website9
########################################################################################
"
read choice ; set_terminal 
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
d) export website="website" ;;
2) export website="website2" ;;
3) export website="website3" ;;
4) export website="website4" ;;
5) export website="website5" ;;
6) export website="website6" ;;
7) export website="website7" ;;
8) export website="website8" ;;
9) export website="website9" ;;
*) invalid ;;
esac
done
return 0
}