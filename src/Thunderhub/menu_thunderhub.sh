function menu_thunderhub {
if ! grep -q "thunderhub-end" $ic ; then return 0 ; fi
while true ; do

source $pc >$dn

if [[ $OS == Mac ]] ; then 
tornotwithmac=""
else
get_onion_address_variable thunderhub
$bright_blue    http://$ONION_ADDR_THUB:2050 $orange
fi

if docker ps 2>$dn | grep -q thunderhub ; then
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
$cyan
                    (log)$orange                 View Docker log file

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
log)
th_log="$(mktemp)"
docker logs thunderhub > $th_log 2>&1
NODAEMON="true" ; pn_tmux "less $th_log" ; unset NODAEMON
rm $th_log >$dn 2>&1
;;
*)
invalid
;;
esac
done
}