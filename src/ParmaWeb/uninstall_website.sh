function uninstall_website {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Website?
$orange

    Please type the name of the database from the list below that you wish to 
    uninstall or anything else to abort. (This will uninstall ParmaWeb, and also
    give you the option to delete the website data directory)
$red
    $(sudo ls /var/www/ | grep website)
    

########################################################################################
"
choose "xpmq" 
read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
website)
if ! sudo test -d /var/www/website ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website"
;;
website2)
if ! sudo test -d /var/www/website2 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website2"
;;
website3)
if ! sudo test -d /var/www/website3 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website3"
;;
website4)
if ! sudo test -d /var/www/website4 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website4"
;;
website5)
if ! sudo test -d /var/www/website5 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website5"
;;
website6)
if ! sudo test -d /var/www/website6 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website6"
;;
website7)
if ! sudo test -d /var/www/website7 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website7"
;;
website8)
if ! sudo test -d /var/www/website8 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website8"
;;
website9)
if ! sudo test -d /var/www/website9 ; then announce "Invalid entry, directory does not exist" ; return 1 ; fi
export website="website9"
;;
*)
invalid
;;
esac

while true ; do
set_terminal ; echo -e "
########################################################################################

    Are you sure you want Parmanode to delete your website directory and database?
$orange
    Please choose: $red
                             delete)     Delete
$green
                             a)          Abort!
$orange
########################################################################################
" ; choose "xpmq" ; read choice ; set_terminal
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; a|A) return 1 ;; m|M) back2main ;;
delete) 
sudo rm -rf /var/www/$website >/dev/null 2>&1
break
;;
*) invalid ;;
esac
done

sudo mysql -u root -p -e "DROP DATABASE $website;"

installed_conf_remove "website-end"

sudo rm -rf /etc/nginx/conf.d/$website* >/dev/null 2>&1
sudo rm -rf /etc/nginx/conf.d/$domain_name.conf >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/$domain_name >/dev/null 2>&1
sudo rm -rf /etc/letsencrypt/live/www.$domain_name >/dev/null 2>&1
sudo systemctl restart nginx >/dev/null 2>&1

parmanode_conf_remove "domain"
parmanode_conf_remove "www"
parmanode_conf_remove "$website" # Includes "website_ssl=true" and "website_database...""
installed_conf_remove "$website"
success "The website has been uninstalled"
}