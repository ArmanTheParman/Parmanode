function uninstall_website {

set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall Website ?
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
case $choice in q|Q) exit 0 ;; p|P) return 1 ;; l|L) break ;;
delete) 
sudo rm -rf /var/www/website >/dev/null 2>&1
;;
*) invalid ;;
esac
done

installed_conf_remove "website-end"

sudo apt-get purge mariadb-client mariadb-client-core mariadb-server-core mariadb-common -y

while true ; do
set_terminal ; echo -y "
########################################################################################

     Remove all MariaDB/MySQL databases too?

                                    y)   yes

                                    n)   no

########################################################################################
"
choose "x" ; read choice
case $choice in
y)
sudo rm -rf /var/lib/mysql
;;
n)
break
;;
*)
invalid
;;
esac
done

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
y)
rm -rf $hp/phpmyadmin ; break
;;
n)
break
;;
*)
invalid
;;
esac
done

installed_conf_remove "website"
success "The website has been uninstalled"
}