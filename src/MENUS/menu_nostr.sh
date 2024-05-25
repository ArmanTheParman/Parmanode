function menu_nostr {
IP_address get #fetches external_IP variable without printed menu

while true ; do
unset nostr_ssl nostr_tor ONION_ADDR_NOSTR N_tor N_tor_logic domain add_domain_name_option domain_name domain_name_text nostr_ssl_status_print
get_onion_address_variable nostr 
source $pc >/dev/null 2>&1

#SSL status
if [[ $nostr_ssl == "true" ]] ; then
nostr_ssl_status_print="${green}ON$orange"
nostr_ssl_port="443"
else
nostr_ssl_status_print="${red}OFF$orange"
fi

#Tor status
if [[ $OS == Linux && -e /etc/tor/torrc ]] ; then
    if sudo cat /etc/tor/torrc | grep -q "nostrrelay" >/dev/null 2>&1 ; then
        if [[ -e /var/lib/tor/nostr-service ]] && \
        sudo cat /var/lib/tor/nostr-service/hostname | grep "onion" >/dev/null 2>&1 ; then
        W_tor="${green}ON${orange}"
        W_tor_logic=on
        else 
        W_tor="${red}OFF${orange}"
        W_tor_logic=off
        fi

        if grep -q "nostr_tor=true" < $HOME/.parmanode/parmanode.conf ; then 
        get_onion_address_variable "nostr" 
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
fi

if [[ -n $ONION_ADDR_NOSTR ]] ; then
tor_menu="        $bright_blue$ONION_ADDR_NOSTR $orange
"
else
unset tor_menu
fi

set_terminal_custom 45 ; echo -ne "
########################################################################################$cyan

                                  NOSTR RELAY$orange

########################################################################################
        $domain_name_text

        Relay Name: $green$relay_name$orange

$tor_menu                      

$yellow
        Nostr data location:      $HOME/.nostr_data
        Nginx configuration:      /etc/nginx/conf.d/website.conf

        TCP Port (http):          ${green}80$yellow
        SSL port (https):         ${green}$nostr_ssl_port $yellow

----------------------------------------------------------------------------------------
 
                 ssl)            $orange SSL enable/disable      $nostr_ssl_status_print   $cyan
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal_custom 45
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
i)
;;

ssl)
nostr_ssl_on
;;

*)
invalid ;;
esac
done
}
