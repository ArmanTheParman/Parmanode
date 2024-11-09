function menu_website {
IP_address get #fetches external_IP variable without printed menu
debug wait
while true ; do
unset website_ssl website_tor ONION_ADDR_WEBSITE W_tor W_tor_logic domain add_domain_name_option domain_name domain_name_text web_ssl_status_print
get_onion_address_variable website
source $pc >/dev/null 2>&1

#SSL status
if [[ $website_ssl == "true" ]] ; then
web_ssl_status_print="${green}ON$orange"
website_ssl_port="443"
else
web_ssl_status_print="${red}OFF$orange"
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "website" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/website-service ]] && \
        sudo cat /var/lib/tor/website-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        W_tor="${green}ON${orange}"
        W_tor_logic=on
        else 
        W_tor="${red}OFF${orange}"
        W_tor_logic=off
        fi

        if grep -q "website_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
        get_onion_address_variable "website" 
        fi
    else
        W_tor="${red}OFF${orange}"
        W_tor_logic=off
    fi
fi

if [[ -n $domain_name ]] ; then
domain_name_text="
        Domain Name:             $cyan $domain_name$orange
"
else
domain_name=$domain
fi

if [[ -n $ONION_ADDR_WEBSITE ]] ; then
tor_menu="        $bright_blue$ONION_ADDR_WEBSITE $orange
"
else
unset tor_menu
fi

set_terminal_custom 45 ; echo -ne "
########################################################################################$cyan

                                  WORDPRESS WEBSITE $orange

########################################################################################
        $domain_name_text
$tor_menu                      

        To initialise:            http://$domain_name/myphpadmin
                                  Database's name: website (or website1, website2 etc)
                                  Database username: parmanode
        Wordpress login:          http://$domain_name/wp-admin
        Info Page:                http://$domain_name/info.php

----------------------------------------------------------------------------------------
$yellow
        Website data location:    /var/www/website
        Data file permissions:    user=www-data ; group=www-data
        Nginx configuration:      /etc/nginx/conf.d/website.conf

        TCP Port (http):          ${green}80$yellow
        SSL port (https):         ${green}$website_ssl_port $yellow
        Tor Status:               $W_tor                     $orange

----------------------------------------------------------------------------------------
                                                                                $cyan
                   i)            $orange Educational info ...                            $cyan
                 max)            $orange How up increase upload file size ...            $cyan
                 dom)            $orange Add/Change domain name                          $cyan
                 dd)             $orange Delete database and create new                  $cyan
                 bk)             $orange Back up database                                $cyan   
                 rs)             $orange Restore backed up database                      $cyan   
 
                 tor)            $orange Tor enable/disable      $W_tor                  $cyan
                 ssl)            $orange SSL enable/disable      $web_ssl_status_print   $cyan
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal_custom 45
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
i)
website_info
;;

open)
port_instructions
;;

tor)
if [[ $W_tor_logic == on ]] ; then 
website_tor_remove
else
website_tor_add
fi
;;

dom)
website_domain
;;

ssl)
if [[ $website_ssl == "true" ]] ; then
    remove_ssl_website 
else
    if [[ -z $domain_name ]] ; then
    announce "Please add a domain name first." 
    continue
    fi

    website_ssl_on
fi
;;

max)
max_upload_file_size_info
;;

dd)
delete_website_database || return 1
success "Database deleted"
create_website_database || return 1
success "Database created"
;;

bk)
backup_website_database || return 1 
success "The database file should now be at$cyan $HOME/Desktop/website_database.sql$orange"
;;

rs)
restore_website_database || return 1 
success "Database restored"
;;

*)
invalid ;;
esac
done
}
