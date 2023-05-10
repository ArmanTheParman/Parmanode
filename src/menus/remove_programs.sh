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
"
elif grep -q "bitcoin-start" $HOME/.parmanode/installed.conf ; then
echo "                                           (bitcoin)          Bitcoin (partial)
" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (f)                Fulcrum Server
"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (f)                Fulcrum (partial) 
" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (d)                Docker 
"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (d)                Docker (partial) 
" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcp)             BTCPay 
"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcp)             BTCPay (partial) 
" ; fi
if grep -q "tor-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (t)                Tor 
"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (t)                Tor (partial)
" ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (lnd)              LND 
"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (lnd)              LND (partial) 
" ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (mem)              Mempool Space 
"
elif grep -q "mempool-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (mem)              Mempool (partial) 
" ; fi
if grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (s)                Sparrow (partial) 
" ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (s)                Sparrow Wallet 
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

s|S|SPARROW|Sparrow|sparrow)
    uninstall_sparrow
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
