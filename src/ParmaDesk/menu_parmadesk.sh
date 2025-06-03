function menu_parmadesk {

while true ; do 
get_onion_address_variable parmadesk
if [[ -n $ONION_ADDR_PARMADESK ]] ; then
    export vnctorprint="Tor Connection:$blue http://$ONION_ADDR_PARMADESK:7010/vnc.html$orange"
else
    export vnctorprint="Tor Connection:$blue http://put_onion_address_here:7010/vnc.html$orange  (onion address not detected)"
fi

if grep -q parmascale-end $ic ; then
parmascaleIP="TailScale/ParmaScale:$blue $(sudo tailscale ip | head -n1 2>$dn)"
else
parmascaleIP="TailScale/ParmaScale:$cyan Not installed. Premium feature for ParmanodL/Parmadrives.$orange"
fi

if sudo systemctl status vnc.service >$dn 2>&1 && sudo systemctl status noVNC.service >$dn 2>&1 ; then 
   export vncprint="${green}RUNNING$orange" ; else vncprint="${red}NOT RUNNING$orange" 
fi
set_terminal 49 110 ; echo -e "
##############################################################################################################$cyan
                                ParmaDesk - Virtual Network Computing Menu            $orange                   
##############################################################################################################


    ParmaDesk is: $vncprint
    
    FROM SAME COMPUTER (pointless)
      TCP Connection:$cyan http://127.0.0.1:21000/vnc.html$orange
      TCP Connection:$cyan http://localhost:21000/vnc.html$orange
      SSL Connection:$cyan http${red}s${cyan}://127.0.0.1:2100${red}1$cyan/vnc.html$orange

    FROM OTHER COMPUTERS ON THE SAME NETWORK:
      SSL Connection:$cyan http${red}s${cyan}://$(cat /etc/hostname):2100${red}1$cyan/vnc.html$orange
      SSL Connection:$cyan http${red}s${cyan}://$IP:2100${red}1$cyan/vnc.html$orange

    FROM OTHER COMPUTERS WORLDWIDE:
      $vnctorprint
      $parmascaleIP
$red
    The terminal window of Parmanode from within the browser connection needs manual resizing with the
    mouse, and then refreshing the page to fix up the formatting derangement.


$green
                                    start)$orange         Start ParmaDesk
                    $red
                                    stop)$orange          Stop ParmaDesk
                    $cyan
                                    restart)$orange       Resart ParmaDesk

$red          Troubleshooting options...
                    $cyan
                                    log)$orange           View log
                    $cyan
                                    hack)$orange          View and tweak xstartup script
                    $cyan
                                    service)$orange       View two service files and status

$orange
##############################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
start_parmadesk
;;
stop)
stop_parmadesk
;;
restart)
restart_parmadesk
;;
"")
continue ;;
log)
ammounce "q to quit once log started."
less ~/.vnc/*.log
;;
hack)
nano ~/.vnc/xstartup ;;
vhack|hackv)
vim ~/.vnc/xstartup ;;
service)
announce "Activating less (uses vim style controls). Exit next screen with 'q'"
{ cat /etc/systemd/system/{vnc.service,noVNC.service} ; sudo systemctl status  vnc.service noVNC.service ; } | less
;;
*)
invalid
;;
esac
done
} 