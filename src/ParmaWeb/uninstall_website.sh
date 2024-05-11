function uninstall_website {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Website?
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose "x" 
read choice
set_terminal

if [[ $choice == "y" || $choice == "Y" ]] ; then true
    else 
    return 1
    fi

while true ; do
set_terminal ; echo -e "
########################################################################################

    Do you want Parmanode to delete your website directory as well? This is the 
    directory with your website pages, located at: $cyan

        /var/www/website/
$orange
    Please choose: $red
                             delete)     Delete
$green
                             l)          Leave it
$orange
########################################################################################
" ; choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; l|L) break ;; m|M) back2main ;;
delete) 
sudo rm -rf /var/www/website >/dev/null 2>&1
break
;;
*) invalid ;;
esac
done

installed_conf_remove "website-end"

while true ; do
set_terminal ; echo -e "
########################################################################################
    Type$cyan no$orange and$cyan <enter>$orange to NOT remove MariaDB.
########################################################################################
" ; read choice ; set_terminal
case $choice in no|N|NO|No) break ;; esac
sudo apt-get purge 'mariadb-client*' 'mariadb-client-core*' 'mariadb-server-core*' 'mariadb-common*' -y
break
done

while true ; do
set_terminal ; echo -e "
########################################################################################
    Type$cyan no$orange and$cyan <enter>$orange to NOT remove php.
########################################################################################
" ; read choice ; set_terminal
case $choice in no|N|NO|No) break ;; esac
sudo apt-get purge 'php-mysql' 'php7.*-mysql' -y
break
done

sudo apt-get autoremove -y
sudo apt-get autoclean -y

while true ; do
set_terminal ; echo -e "
########################################################################################

    Delete any existing phpmyadmin directory?
   $green
    y) yes
$red
    n) no
$orange
########################################################################################
"
choose "xpmq" ; read choice
case $choice in
q|Q) exit 0 ;; p|P|M|m) back2main ;;
y|yes)
rm -rf $hp/phpmyadmin ; break
;;
n|no)
break
;;
*)
invalid
;;
esac
done

sudo rm -rf /etc/nginx/conf.d/website* >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/$domain_name >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/www.$domain_name >/dev/null 2>&1
sudo systemctl restart nginx >/dev/null 2>&1

parmanode_conf_remove "domain"
parmanode_conf_remove "www"
parmanode_conf_remove "website" # Includes "website_ssl=true" and "website_database...""
installed_conf_remove "website"
success "The website has been uninstalled"
}