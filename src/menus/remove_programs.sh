function remove_programs {

if ! grep -q parmanode $HOME/.parmanode/installed.conf ; then 
set_terminal ; echo "
########################################################################################

    Intsall Parmanode before trying to remove anyting... obviously!

########################################################################################
"
enter_continue
return 1 
fi

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
echo "                                           (fulcrum)          Fulcrum Server
"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (fulcrum)          Fulcrum (partial)
" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (docker)           Docker 
"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (docker)           Docker (partial) 
" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcp)             BTCPay 
"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcp)             BTCPay (partial) 
" ; fi
if which tor >/dev/null 2>&1 ; then                               
echo "                                           (tor)              Tor 
"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (tor)              Tor (partial)
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
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (s)                Sparrow Wallet 
"  
elif grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (s)                Sparrow (partial) 
" ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (r)                RTL Wallet 
"  
elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (r)                RTL (partial) 
" ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (e)                Electrum Wallet 
"  
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (e)                Electrum (partial) 
" ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (ts)               Tor Server 
"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (ts)               Tor Server (partial) 
" ; fi
if grep -q "btcpTOR-end" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcpt)            Tor Server 
"
elif grep -q "btcpTOR-start" $HOME/.parmanode/installed.conf ; then                               
echo "                                           (btcpt)            Tor Server (partial) 
" ; fi
echo "
########################################################################################
"
choose "xpq"
read choice

case $choice in

parmanode|PARMANODE|Parmanode)
uninstall_parmanode
exit 0
;;

bitcoin|Bitcoin|BITCOIN)
uninstall_bitcoin
return 0
;;

fulcrum|Fulcrum|FULCRUM)
uninstall_fulcrum
return 0
;;

docker|Docker|DOCKER)
if [[ $OS == "Mac" ]] ; then uninstall_docker_mac ; continue ; fi
uninstall_docker_linux 
return 0
;;

btcp|BTCP|Btcp)
uninstall_btcpay
return 0
;;

TOR|Tor|tor)
no_mac || return 1
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
R|r|RTL|rtl|Rtl)
	uninstall_rtl
	return 0
	;;

e|E|Electrum|electrum|ELECTRUM)
    uninstall_electrum
	return 0
	;;
ts|TS|Ts)
	no_mac || return 1
	uninstall_tor_server
	return 0
	;;
btcpt|BTCPT)
	uninstall_btcpay_tor

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
