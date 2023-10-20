function menu_rtl {
while true ; do set_terminal ; echo -e "
########################################################################################
                                 $cyan   RTL Menu     $orange 
########################################################################################
"
if docker ps >/dev/null ; then echo -e "
                                 RTL is RUNNING" ; fi
if ! docker ps >/dev/null ; then echo -e "
                                 RTL is NOT RUNNING" ; fi
echo -e "      


      (start)          Start RTL Docker container

      (stop)           Stop RTL Docker container

      (restart)        Restart RTL Docker container

      (pw)             Password Change



      The RTL wallet can be accessed in your browser at:

$green
                               http://localhost:3000
$orange

########################################################################################
"
choose "xpq" ; read choice ; set_terminal
case $choice in 
q|Q|QUIT|Quit) exit 0 ;;

p|P) return 1 ;;

start|Start|START|S|s)
docker start rtl
continue
;;

stop|STOP|Stop)
docker stop rtl
continue
;;

restart|RESTART|Restart)
docker stop rtl 
docker start rtl
continue
;;

pw|Pw|PW)
rtl_password
continue
;;
*)
invalid
;;

esac
done
}
