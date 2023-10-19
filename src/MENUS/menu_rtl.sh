function menu_rtl {
while true ; do set_terminal ; echo -e "
########################################################################################
                                 $cyan   RTL Menu     $orange 
########################################################################################

      The RTL wallet can be accessed in your browser at:

                               http://localhost:3000


      (start)          Start RTL Docker container

      (stop)           Stop RTL Docker container

      (restart)        Restart RTL Docker container


      PASSWORD CHANGE - USE THE RTL GUI

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;
p|P) return 1 ;;

start|Start|START|S|s)
docker start rtl
return 0 ;;

stop|STOP|Stop)
docker stop rtl
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
