function menu_thub {

while true ; do

source $pc >/dev/null

if docker ps 2>/dev/null | grep -q thunderhub ; then
running="                           Thunderhub is$green    Running$orange
"
else
running="                           Thunderhub is$red    Not Running$orange
"
fi
set_terminal ; echo -en "
########################################################################################
               $cyan                Thunderhub Menu            $orange                   
########################################################################################

$running

                    (start)               Start Thunderhub 

                    (stop)                Stop Thunderhub

                    (restart)             Must I tell you what this does?

    Connection URL:
$cyan
    http://127.0.0.1:$thub_port 
    http://$IP:$thub_port
    http://$ONION_ADDR_THUB:2050
$orange
########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
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