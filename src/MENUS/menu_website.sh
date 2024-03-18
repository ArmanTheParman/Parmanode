function menu_website {
source $pc >/dev/null 2>&1

while true ; do
set_terminal ; echo -ne "
########################################################################################
$cyan
                                  WORDPRESS WEBSITE 
$orange
    Website data location:    /var/www/website
    Data file permissions:    user=www-data ; group=www-data
    Nginx configuration:      /etc/nginx/conf.d/website.conf
    To initialise:            http://$domain/myphpadmin
    Wordpress login:          http://$domain/wp-admin
    Port:                     80
    SSL port:                 $website_ssl_port 
    Tor:                      $website_tor
$cyan
    i)                       $orange INFO $cyan
    tor)                     $orange Tor enable/disable     $web_tor_status_print    $cyan
    ssl)                     $orange SSL enable/disable     $web_ssl_status_print    $cyan

$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;;
i)
website_info
;;
tor)
website_tor_toggle
;;
ssl)
website_ssl_toggle
;;
*)
invalid ;;
esac
done


}