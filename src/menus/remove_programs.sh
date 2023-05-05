function remove_programs {

while true ; do
set_terminal

echo "
########################################################################################

                                   Remove Programs


                           (bitcoin)          Bitcoin Core
                               
                           (f)                Fulcrum Server 

                           (d)                Docker

                           (btcp)             BTCPay Server

                           (t)                Tor
						   
						   (lnd)              LND

########################################################################################

"
choose "xpq"
read choice

case $choice in

bitcoin|Bitcoin|BITCOIN)
uninstall_bitcoin
return 0
;;

f|F)
uninstall_fulcrum
return 0
;;

d|D) 
if [[ $OS == "Mac" ]] ; then no mac ; continue ; fi
uninstall_docker_linux 
return 0
;;

btcp|BTCP|Btcp)
uninstall_btcpay
return 0
;;

t|T|TOR|Tor|tor)
uninstall_tor
return 0
;;

lnd|LND|Lnd)
if [[ $OS == "Linux" ]] ; then uninstall_lnd ; fi
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
