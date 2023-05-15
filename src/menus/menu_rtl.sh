function menu_rtl {
while true ; do set_terminal ; echo "
########################################################################################
                                    RTL Menu                               
########################################################################################

      The RTL wallet can be accessed in your browser at:

                               http://localhost:3000



      (start)          Start RTL Docker container

      (stop)           Stop RTL Docker container

      (pass)           Change RTL Password (requires manual restart)

      (restart)        Restart RTL Docker container

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
docker stop rtl
return 0 ;;

stop|STOP|Stop)
docker start rtl
return 0 ;;

restart|RESTART|Restart)
docker stop rtl 
docker start rtl
return 0 
;;

*)
invalid
;;

esac
done
}
