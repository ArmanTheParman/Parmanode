function menu_rtl {
if ! grep -q "rtl-end" $ic ; then return 0 ; fi
while true ; do 
unset tor_message ONION_ADDR_RTL

if grep -q "rtl_tor" $pc ; then
get_onion_address_variable rtl
tor_message="      RTL Onion Address:$bright_blue

            $ONION_ADDR_RTL:7005 $orange
                  "
fi 

set_terminal 
echo -e "
########################################################################################
                                 $cyan   RTL Menu     $orange 
########################################################################################
"
if docker ps | grep -q rtl ; then echo -e "
                                 RTL is$green RUNNING$orange" 
else 
echo -e "
                                 RTL is$red NOT RUNNING$orange"
fi

if ! ps -x | grep lnd | grep bin >$dn 2>&1  && ! docker ps | grep -q lnd ; then echo -e "$red
                WARNING: LND is not running. RTL won't funciton.$orange" ; fi

echo -e "      

$green
      (start)$orange          Start RTL Docker container
$red
      (stop)$orange           Stop RTL Docker container
$cyan
      (restart)$orange        Restart RTL Docker container
$cyan
      (pw)$orange             Password Change
$cyan
      (lnd)$orange            Reinstall RTL to reconnect with LND (need if LND reset)
$cyan
      (t)$orange              Enable/Disable RTL access over Tor

      

      The RTL wallet can be accessed in your browser at:
$green
                       http://localhost:3000 
                       http://$IP:3000 $orange

$tor_message
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;;
p|P) 
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use ;; 

start|Start|START|S|s)
start_rtl
continue
;;

stop|STOP|Stop)
docker stop rtl
continue
;;

restart|RESTART|Restart)
docker stop rtl 
start_rtl
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
clear
if ! grep -q "rtl_tor" $pc ; then
enable_tor_rtl
else
disable_tor_rtl
fi
sleep 2.5

;;

*)
invalid
;;

esac
done
}
