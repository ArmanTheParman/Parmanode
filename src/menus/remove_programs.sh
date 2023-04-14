function remove_programs {

while true ; do
set_terminal

echo "
########################################################################################

                                   Remove Programs


                                (b)      Bitcoin Core
				  
########################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
if [[ $OS == "Linux" ]] ; then uninstall_bitcoin_linux ; fi
if [[ $OS == "Mac" ]] ; then uninstall_bitcoin_mac; fi

uninstall_bitcoin_mac
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
