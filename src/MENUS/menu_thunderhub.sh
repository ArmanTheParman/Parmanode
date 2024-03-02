function menu_thunderhub {
source $pc >/dev/null
while true ; do set_terminal ; echo -e "
########################################################################################
               $cyan                Thunderhub Menu            $orange                   
########################################################################################


                    (start)               Start Thunderhub 

                    (stop)                Stop Thunderhub


    Connection URL:
$cyan
    http://127.0.01:$thub_port 
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
*)
invalid
;;
esac
done
}