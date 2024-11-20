function menu_thunderhub {


while true ; do

source $pc >/dev/null

if [[ $OS == Mac ]] ; then 
tornotwithmac=""
else
get_onion_address_variable thunderhub
$bright_blue    http://$ONION_ADDR_THUB:2050 $orange
fi

if docker ps 2>/dev/null | grep -q thunderhub ; then
running="
                           Thunderhub is$green    Running$orange
"
else
running="
                           Thunderhub is$red    Not Running$orange
"
fi
set_terminal ; echo -en "
########################################################################################
               $cyan                Thunderhub Menu            $orange                   
########################################################################################


$running
$green
                    (start)$orange               Start Thunderhub 
$red
                    (stop)$orange                Stop Thunderhub
$cyan
                    (restart)$orange             Must I tell you what this does?

    Connection URL:
$cyan
    http://127.0.0.1:$thub_port 
    http://$IP:$thub_port
$tornotwithmac
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;;
p|P)
if [[ $1 == overview ]] ; then return 0 ; fi
menu_use
;;
start|Start|START|S|s)
start_thunderhub
;;
stop)
stop_thunderhub
;;
restart)
stop_thunderhub
start_thunderhub
;;
*)
invalid
;;
esac
done
}