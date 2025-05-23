function menu_nostr {
if ! grep -q "nostrrelay-end" $ic ; then return 0 ; fi
IP_address get #fetches external_IP variable without printed menu
while true ; do
unset nostr_ssl ONION_ADDR_NOSTR domain domain_name domain_name_text running_nostr_menu
get_onion_address_variable nostr 
source $pc >$dn 2>&1

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

#data location
source $pc
if [[ $drive_nostr == external ]] ; then 
nostr_data_location="$pd/nostr_data"
elif [[ $drive_nostr == internal ]] ; then 
nostr_data_location="$HOME/.nostr_data"
elif [[ $drive_nostr == custom ]] ; then 
nostr_data_location="$drive_nostr_custom_data"
fi


if [[ -n $domain_name ]] ; then
domain_name_text="
        Domain Name:             $bright_magenta $domain_name$orange
        "
location=$domain_name
else
domain_name_text="
        Domain Name:              NOT SET
        "
location=$domain
fi


if [[ -n $ONION_ADDR_NOSTR ]] ; then
tor_menu="        $bright_blue$ONION_ADDR_NOSTR${yellow}:7081 $orange
"
else
unset tor_menu
fi

set_terminal 48 88 ; echo -ne "
########################################################################################$cyan

                                N O S T R  RELAY$orange

########################################################################################


$running_nostr_menu


        Relay Name:               $bright_magenta$relay_name$orange
        $domain_name_text
        Local IP & Port           $IP${yellow}:7080$orange    (routed to Docker container)

        Docker Container IP       $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nostrrelay)${yellow}:8080 $orange

$tor_menu                      $orange
        Nostr data location:      $nostr_data_location

        Data usage:               $green$(du -shL $nostr_data_location | cut -f1)$orange

        Nginx configuration:      /etc/nginx/conf.d/$domain_name.conf


########################################################################################


$cyan            s)$orange                Start Nostr (starts Docker container) 

$cyan            stop)$orange             Stop Nostr 

$cyan            rs)$orange               Restart Nostr

$cyan            conf)$orange             View/edit nginx conf (confv for vim)

$cyan            toml)$orange             View/edit config.toml file (tomlv for vim)

$cyan            log)$orange              View relay log

$cyan            test)$orange             Send a test connection

            $ssl_menu 


########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } 
set_terminal 45 88
case $choice in
q|Q) exit 0 ;; p|P) return 1 ;; m|M) back2main ;;
i)
;;

s|start)
start_nostrrelay
;;
stop)
stop_nostrrelay
;;
rs)
stop_nostrrelay
start_nostrrelay
;;
conf)
sudo nano /etc/nginx/conf.d/$domain_name.conf
;;
confv)
vim_warning ; sudo vim /etc/nginx/conf.d/$domain_name.conf
;;
toml)
nano $HOME/parmanode/nostrrelay/config.toml
;;
tomlv)
vim_warning ; vim $HOME/parmanode/nostrrelay/config.toml
;;
log)
log_counter
if [[ $log_count -le 50 ]] ; then
echo -e "
########################################################################################
    
    This will show the last 100 lines of the log file from Docker, and more in 
    real-time as it populates.
    
    You can hit$cyan <control>-c$orange to make it stop.

########################################################################################
"
enter_continue ; jump $enter_cont
fi

set_terminal 38 200
docker logs nostrrelay -f --tail 100 &
tail_PID=$!
trap 'kill $tail_PID' SIGINT #condition added to memory
wait $tail_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
continue ;;

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
"")
continue ;;
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



    You can also enter your relay's domain here to test it: $green https://nostrrr.com/ $orange



$cyan          http)$orange       send a connection request over http (unencrypted)

$cyan          https)$orange      send a connection request over SSL

$cyan          e1)$orange         only use this to see http error output

$cyan          e2)$orange         only use this to see https error output


########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
http)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $location" -H "Origin: http://$location" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" http://$location &
curl_PID=$!
trap 'kill $curl_PID' SIGINT #condition added to memory
wait $curl_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
break
;;
https)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $location" -H "Origin: https://$location" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" https://$location &
curl_PID=$!
trap 'kill $curl_PID' SIGINT #condition added to memory
wait $curl_PID # code waits here for user to control-c
trap - SIGINT # reset the trap so control-c works elsewhere.
break
;;
e1)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $location" -H "Origin: http://$location" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" http://$location
enter_continue
break
;;
e2)
curl -i -N -H "Connection: Upgrade" -H "Upgrade: websocket" -H "Host: $location" -H "Origin: https://$location" -H "Sec-WebSocket-Key: SGVsbG8sIHdvcmxkIQ==" -H "Sec-WebSocket-Version: 13" https://$location
enter_continue
break
;;
"")
continue ;;
*)
invalid
;;
esac
done


}