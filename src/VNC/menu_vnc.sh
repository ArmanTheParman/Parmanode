function menu_vnc {

while true ; do 
get_onion_address_variable vnc
if [[ -n $ONION_ADDR_VNC ]] ; then
    export vnctorprint="Tor Connection:$blue http://$ONION_ADDR_VNC:7010/vnc.html$orange"
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
set_terminal 40 110 ; echo -e "
##############################################################################################################$cyan
                                      Virtual Network Computing Menu            $orange                   
##############################################################################################################


    VNC is: $vncprint
    
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
    $orange

$green
                                      start)$orange         Start VNC
                    $red
                                      stop)$orange          Stop VNC 
                    $cyan
                                      restart)$orange       Resart VNC 
                    $cyan
                                      log)$orange           View log
                    $cyan
                                      kill)$orange          Aggressive stop (if issues)


$orange
##############################################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 
start|Start|START|S|s)
start_vnc
;;
stop)
stop_vnc
;;
restart)
restart_vnc
;;
"")
continue ;;
log)
ammounce "q to quit once log started."
less ~/.vnc/*.log
;;
kill)
vncserver -kill :1
rm -rf /tmp/.X1-lock /tmp/.X11-unix/X1 ~/.vnc/*:1.*
;;
;;
*)
invalid
;;
esac
done
} 