function menu_rtl {



while true ; do 
unset tor_message ONION_ADDR_RTL

if grep -q < $dp/parmanode.conf ; then
get_onion_address_variable rtl
tor_message="      RTL Onion Address:

                   $ONION_ADDR_RTL
                   "
fi 

set_terminal 
echo -e "
########################################################################################
                                 $cyan   RTL Menu     $orange 
########################################################################################
"
if docker ps >/dev/null ; then echo -e "
                                 RTL is RUNNING" ; fi
if ! docker ps >/dev/null ; then echo -e "
                                 RTL is NOT RUNNING" ; fi
if ! ps -x | grep lnd | grep bin >/dev/null 2>&1 ; then echo -e "$red
                WARNING: LND is not running. RTL won't funciton.$orange" ; fi

echo -e "      


      (start)          Start RTL Docker container

      (stop)           Stop RTL Docker container

      (restart)        Restart RTL Docker container

      (pw)             Password Change

      (lnd)            Reinstall RTL to reconnect with LND (need if LND reset)

      (t)              Enable/Disable RTL access over Tor

      

      The RTL wallet can be accessed in your browser at:
$green
                         http://localhost:3000 $orange
$

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;

q|Q|QUIT|Quit) exit 0 ;;

p|P) menu_use ;; 

start|Start|START|S|s)
docker start rtl
continue
;;

stop|STOP|Stop)
docker stop rtl
continue
;;

restart|RESTART|Restart)
docker stop rtl 
docker start rtl
continue
;;

pw|Pw|PW)
rtl_password
continue
;;

lnd|LND|Lnd)
reset_rtl_lnd
continue
;;

t|T|tor|Tor|TOR)
if ! grep -q "rtl_tor" < $dp/parmanode.conf ; then
enable_tor_rtl
else
disable_tor_rtl
fi

;;

*)
invalid
;;

esac
done
}
