function menu_vnc {

while true ; do 

if sudo systemctl status vnc.service >$dn 2>&1 && sudo systemctl status novnc.service >$dn 2>&1 ; then 
   export vncprint="${green}RUNNING$orange" ; else vncprint="${red}NOT RUNNING$orange" 
fi
set_terminal 40 110 ; echo -e "
##############################################################################################################$cyan
                                      Virtual Network Computing Menu            $orange                   
##############################################################################################################

    VNC is: $vncprint

    Connection :$cyan  http://localhost:19080 ; http://$IP:19080 ; http://127.0.0.1:19080$orange

$green
                                      start)$orange         Start VNC
                    $red
                                      stop)$orange          Stop VNC 
                    $cyan
                                      restart)$orange       Resart VNC 

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
*)
invalid
;;
esac
done
} 