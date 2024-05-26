function menu_nostr {
IP_address get #fetches external_IP variable without printed menu

while true ; do
unset nostr_ssl ONION_ADDR_NOSTR domain domain_name domain_name_text running_nostr_menu
get_onion_address_variable nostr 
source $pc >/dev/null 2>&1

#running status
if docker ps | grep -q nostrrelay ; then 
running_nostr_menu="                                NOSTR IS$green RUNNING$orange"
else
running_nostr_menu="                              NOSTR IS$red NOT RUNNING$orange"
fi


#SSL status
if [[ $nostr_ssl == "true" ]] ; then
nostr_ssl_status_print="${green}ON$orange"
nostr_ssl_port="443"
ssl_menu="${cyan}ssl)$orange                     $orange $nostr_ssl_status_print"
else
nostr_ssl_status_print="${red}OFF$orange"
ssl_menu="ssl)                     $orange Enable SSL $nostr_ssl_status_print"
fi



if [[ -n $domain_name ]] ; then
domain_name_text="
        Domain Name:             $bright_magenta $domain_name$orange"
fi

if [[ -n $ONION_ADDR_NOSTR ]] ; then
tor_menu="        $bright_blue$ONION_ADDR_NOSTR${yellow}:7081 $orange
"
else
unset tor_menu
fi

set_terminal_custom 48 ; echo -ne "
########################################################################################$cyan

                                N O S T R  RELAY$orange

########################################################################################


$running_nostr_menu


        Relay Name:               $relay_name
        $domain_name_text

$tor_menu                      $orange
        Local IP & Port           $IP${yellow}:7080$orange    (routed to Docker container)

        Docker Container IP       $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nostrrelay)${yellow}:8080 $orange
$orange
        Nostr data location:      $HOME/.nostr_data

        Nginx configuration:      /etc/nginx/conf.d/$domain_name.conf

########################################################################################


$cyan        s)$orange                        Start Nostr (starts Docker container) 

$cyan        stop)$orange                     Stop Nostr 

$cyan        conf)$orange                     View/edit nginx conf (be careful)

$cyan        log)$orange                      View Docker logs
        
$cyan        test)$orange                     Send a test connection
        
        $ssl_menu 

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal_custom 45
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
i)
;;
conf)
sudo nano /etc/nginx/conf.d/$domain_name.conf
;;
log)
docker logs nostrrelay
enter_continue
;;
test)
nostr_curl_test
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

function nostr_curl_test {
while true ; do
set_terminal ; echo -e "
########################################################################################

    A 'curl' test will be sent to the server. If you get no output, something is
    wrong. See last output from the menu below. If you do see an ouput, then you're
    probably connected, and you can hit$cyan <control>-c$orange to exit.

$cyan          http)$orange       send a connection request over http (unencrypted)

$cyan          https)$orange      send a connection request over SSL

$cyan          e1)$orange         only use this to see http error output

$cyan          e2)$orange         only use this to see https error output

########################################################################################
"
choose xpmq ; read choice ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;;
http)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $domain_name" -H "Origin: http://$domain_name" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" http://$domain_name  &
curl_PID=$!
trap 'kill $curl_PID' SIGINT #condition added to memory
wait $curl_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
break
;;
https)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $domain_name" -H "Origin: https://$domain_name" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" https://$domain_name &
curl_PID=$!
trap 'kill $curl_PID' SIGINT #condition added to memory
wait $curl_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
break
;;
e1)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $domain_name" -H "Origin: http://$domain_name" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" http://$domain_name 
enter_continue
break
;;
e2)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $domain_name" -H "Origin: https://$domain_name" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" https://$domain_name 
enter_continue
break
;;
*)
invalid
;;
esac
done


}