function menu_website {
ip_address get #fetches external_IP variable without printed menu

while true ; do
unset website_tor ONION_ADDR_WEBSITE W_tor W_tor_logic domain add_domain_name_option domain_name domain_name_text
get_onion_address_variable website
source $pc >/dev/null 2>&1

#SSL status
if [[ $website_ssl == true ]] ; then
web_ssl_status_print="$green ON$orange"
website_ssl_port="443 (https)"
else
web_ssl_status_print="$red OFF$orange"
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then

    if sudo cat /etc/tor/torrc | grep -q "website" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/website-service ]] && \
        sudo cat /var/lib/tor/website-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        W_tor="${green}ON${orange}"
        W_tor_logic=on
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
domain_name_text="    Domain Name:              $domain_name"
fi

set_terminal ; echo -ne "
########################################################################################
$cyan
                                  WORDPRESS WEBSITE 
$orange
    Website data location:    /var/www/website
    Data file permissions:    user=www-data ; group=www-data
    Nginx configuration:      /etc/nginx/conf.d/website.conf
$domain_name_text
    To initialise:            http://$domain/myphpadmin
    Wordpress login:          http://$domain/wp-admin
    Port:                     80
    SSL port:                 $website_ssl_port 
    Tor Status:               $W_tor
    Tor:                      $website_tor

----------------------------------------------------------------------------------------
                                                                                $cyan
          i)            $orange INFO                                            $cyan
        max)            $orange How up increase upload file size                $cyan
        tor)            $orange Tor enable/disable     $W_tor                   $cyan
        dom)            $orange Add/Change domain name                          $cyan
        ssl)            $orange SSL enable             $web_ssl_status_print    $cyan

$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;;
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
if [[ $website_ssl == true ]] ; then
    continue
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

*)
invalid ;;
esac
done
}

function website_ssl_on {

if ! nmap -p 80 $external_IP | grep 80 | grep -q open ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Please be aware that for this to work, you must have$pink port 80$orange opened on your
    router and forwarded to this machine, otherwise the certificate generation
    process will fail.
    
    To continue, type$cyan free ross$orange and$cyan <enter>$orange otherwise just hit$red <enter>$orange to
    abort this.

########################################################################################
"
choose "x" ; read choice ; set_terminal 
case $choice in
"free ross" | "Free Ross" | "free Ross" | "free Ross" | "freeross")
break
;;
*)
return 1
;;
esac
done
fi

# Before using certbot, backup website.conf
sudo cp /etc/nginx/conf.d/website.conf /etc/nginx/conf.d/website.conf_backup >/dev/null 2>&1
#
# Run cerbot
# Port 80 needs to be open. 
certbot --nginx -d $domain_name || { echo -e "\nSomething went wrong" ; enter_continue ; return 1 ; }

parmanode_conf_add "website_ssl=true"
success "SSL has been turned on for your website"
}

function max_upload_file_size_info {
set_terminal ; echo -e "
########################################################################################

    Google it.

########################################################################################
"
enter_coninue
set_terminal ; echo -e "
########################################################################################

    Just kidding!

    You need to edit the php.ini file. There are more than one of these, you go 
    need to edit the correct one. It should be in...
$cyan
        /etc/php/${red}7.4$cyan/fpm/php.ini
$orange
    Obviously, if a new version comes out, you need to change$red 7.4$orange to the 
    right number. Also, make sure you are in the fpm subdirectory no cli, as there is
    a php.ini file in there as well, but it's not the one you need.

    Then in the file edit the values of: $cyan
        
        post_max_size=
$orange& $cyan
        upload_max_filesize= $orange
    
    Then save the file and restart php... $cyan

        sudo systemctl restart php7.4-fpm.service $orange

    In case the file name changes type up to php7 and then hit <tab> to autocomplete.

########################################################################################
" ; enter_coninue

return 0
}