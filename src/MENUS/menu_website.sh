function menu_website {
ip_address get #fetches external_IP variable without printed menu

while true ; do
unset website_tor ONION_ADDR_WEBSITE W_tor W_tor_logic domain add_domain_name_option
get_onion_address_variable website
source $pc >/dev/null 2>&1

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then

    if sudo cat /etc/tor/torrc | grep -q "website" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/website-service ]] && \
        sudo cat /var/lib/tor/website-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        W_tor="${green}on${orange}"
        W_tor_logic=on
        fi

        if grep -q "website_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
        get_onion_address_variable "website" 
        fi
    else
        W_tor="${red}off${orange}"
        W_tor_logic=off
    fi
fi

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
    Tor Status:               $W_tor
    Tor:                      $website_tor

----------------------------------------------------------------------------------------
                                                                                $cyan
          i)            $orange INFO                                            $cyan
       open)            $orange Instructions to open ports on router            $cyan
        tor)            $orange Tor enable/disable     $web_tor_status_print    $cyan
        dom)            $orange Change domain                                   $cyan
        ssl)            $orange SSL enable/disable     $web_ssl_status_print    $cyan

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
website_ssl_off
else
website_ssl_on
fi
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

#
#
#
#
#
#

parmanode_conf_add "website_ssl=true"
success "SSL has been turned on for your website"
}




function website_ssl_off {
parmanode_conf_remove "website_ssl="
success "SSL has been turned off for your website"
}