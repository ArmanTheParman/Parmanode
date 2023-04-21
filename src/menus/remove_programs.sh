function remove_programs {

while true ; do
set_terminal

echo "
########################################################################################

                                   Remove Programs


                               (b)      Bitcoin Core
                               
                               (f)      Fulcrum Server

########################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
uninstall_bitcoin
return 0
;;

f|F)
uninstall_fulcrum
return 0
;;

p|P)
	return 0
	;;

q|Q|QUIT|quit|Quit)
	exit 0
	;;
*)
	invalid
	continue
	;;
esac

done

return 0
}
