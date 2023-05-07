function remove_programs {
source $HOME/.parmanode/installed.conf
while true ; do
set_terminal

echo "
########################################################################################

             Remove Programs

"
if grep -q "parmanode-end" $HOME/.parmanode/installed.conf ; then
echo "                                           (parmanode)        Parmanode
" ; fi
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then
echo "                                           (bitcoin)          Bitcoin Core
" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (f)                Fulcrum Server 
" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (d)                Docker 
" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcp)             BTCPay 
" ; fi
if grep -q "tor-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (t)                Tor 
" ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (lnd)              LND 
" ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (mem)              Mempool Space 
" ; fi
echo "
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
if [[ $OS == "Linux" ]] ; then uninstall_lnd ; return 0 ; fi
;;

mem|MEM|Mem)
uninstall_mempool
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
