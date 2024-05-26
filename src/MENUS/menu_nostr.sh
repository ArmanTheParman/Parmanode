function menu_nostr {
IP_address get #fetches external_IP variable without printed menu

while true ; do
unset nostr_ssl ONION_ADDR_NOSTR domain domain_name domain_name_text 
get_onion_address_variable nostr 
source $pc >/dev/null 2>&1

#SSL status
if [[ $nostr_ssl == "true" ]] ; then
nostr_ssl_status_print="${green}ON$orange"
nostr_ssl_port="443"
ssl_menu="ssl)                     $orange $nostr_ssl_status_print"
else
nostr_ssl_status_print="${red}OFF$orange"
ssl_menu="ssl)                     $orange Enable SSL $nostr_ssl_status_print"
fi



if [[ -n $domain_name ]] ; then
domain_name_text="
        Domain Name:             $cyan $domain_name$orange
"
fi

if [[ -n $ONION_ADDR_NOSTR ]] ; then
tor_menu="        $bright_blue$ONION_ADDR_NOSTR${green}:7081 $orange
"
else
unset tor_menu
fi

set_terminal_custom 45 ; echo -ne "
########################################################################################$cyan

                                N O S T R  RELAY$orange

########################################################################################
        $domain_name_text

        Relay Name:               $relay_name

        Local IP & Port           $IP${green}:7080$orange    (routed to Docker container)

        Docker Container IP       $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nostrrelay)${green}:8080 $orange
$orange
        Nostr data location:      $HOME/.nostr_data

        Nginx configuration:      /etc/nginx/conf.d/website.conf
        
        $ssl_menu 
$tor_menu                      $orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal_custom 45
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
i)
;;

ssl)
if [[ $nostr_ssl == "true" ]] ; then
announce "SSL already enabled"
continue
fi

nostrrelay_ssl_on
;;

*)
invalid ;;
esac
done
}
