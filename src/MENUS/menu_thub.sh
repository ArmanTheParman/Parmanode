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

    Connection URL:
$cyan
    http://127.0.0.1:$thub_port 
    http://$IP:$thub_port
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
return 0
;;
stop)
stop_thunderhub
return 0
;;
*)
invalid
;;
esac
done
}