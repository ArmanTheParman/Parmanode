function menu_lnbits {
while true ; do set_terminal ; echo -e "
########################################################################################
                                $cyan LNbits Menu     $orange 
########################################################################################

      The LNbits can be accessed in your browser at:

$yellow
                               http://localhost:5000
$orange
                               or
$yellow
                               http://$IP:5000

$cyan
      (start)$orange          Start LNbits Docker container
$cyan
      (stop)$orange           Stop LNbits Docker container
$cyan
      (restart)$orange        Restart LNbits Docker container

########################################################################################
"
choose "xpmq" ; read choice ; set_terminal
case $choice in 
m|M) back2main ;;
q|Q|QUIT|Quit) exit 0 ;;
p|P) menu_use ;; 
start|Start|START|S|s)
start_lnbits
return 0 ;;

stop|STOP|Stop)
stop_lnbits
return 0 ;;

restart|RESTART|Restart)
restart_lnbits
return 0 
;;

*)
invalid
;;

esac
done
}
