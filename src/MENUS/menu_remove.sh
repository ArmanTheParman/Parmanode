function menu_remove {
# another dynamic menu. Each program is listed either as available to be removed, 
# or as a partial (failed) installation, that can be removed. The menu variable is 
# set to toggle the availability of the menu logic below, via if statements.

while true ; do
local num=$(cat $dp/installed.conf | wc -l >/dev/null)
debug4 "num is $num"
local num2=$(( 42 + (num/2 - 14) ))
debug4 "num is $num and num2 is $num2"
set_terminal_custom 42
unset bitcoinmenu fulcrummenu dockermenu btcpaymenu lnbitsmenu tormenu lndmenu mempoolmenu 
unset sparrowmenu rtlmenu electrummenu torservermenu btcTORmenu spectermenu btcrpcexplorermenu
unset electrsmenu trezormenu ledgermenu bitboxmenu parmashellmenu bredockermenu parmaboxmenu
unset anydeskmenu

echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Remove Programs$orange                               #
#                                                                                      #
########################################################################################
#                                                                                      #"
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo "#                                    (bitcoin)          Bitcoin Core                   #
#                                                                                      #"
elif grep -q "bitcoin-start" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo "#                                    (bitcoin)          Bitcoin (partial)              #
#                                                                                      #" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrummenu=1 
echo "#                                    (fulcrum)          Fulcrum Server                 #
#                                                                                      #"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then fulcrummenu=1                                
echo "#                                    (fulcrum)          Fulcrum (partial)              #
#                                                                                      #" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then dockermenu=1 
echo "#                                    (docker)           Docker                         #
#                                                                                      #"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then dockermenu=1                       
echo "#                                    (docker)           Docker (partial)               #
#                                                                                      #" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpaymenu=1              
echo "#                                    (btcp)             BTCPay                         #
#                                                                                      #"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then btcpaymenu=1
echo "#                                    (btcp)             BTCPay (partial)               #
#                                                                                      #" ; fi
#############################
if [[ $OS != "Mac" ]] ; then
if which tor >/dev/null 2>&1 ; then tormenu=1
echo "#                                    (tor)              Tor                            #
#                                                                                      #"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then tormenu=1
echo "#                                    (tor)              Tor (partial)                  #
#                                                                                      #" ; fi
fi
#############################
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo "#                                    (lnd)              LND                            #
#                                                                                      #"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo "#                                    (lnd)              LND (partial)                  #
#                                                                                      #" ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo "#                                    (mem)              Mempool Space                  #
#                                                                                      #"
elif grep -q "mempool-start" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo "#                                    (mem)              Mempool (partial)              #
#                                                                                      #" ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo "#                                    (s)                Sparrow Wallet                 #
#                                                                                      #"  
elif grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo "#                                    (s)                Sparrow (partial)              #
#                                                                                      #" ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo "#                                    (r)                RTL Wallet                     #
#                                                                                      #" 
elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo "#                                    (r)                RTL (partial)                  #
#                                                                                      #" ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo "#                                    (e)                Electrum Wallet                #
#                                                                                      #"  
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo "#                                    (e)                Electrum (partial)             #
#                                                                                      #" ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo "#                                    (ts)               Tor Server                     #
#                                                                                      #"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo "#                                    (ts)               Tor Server (partial)           #
#                                                                                      #" ; fi
if grep -q "btcpTOR-end" $HOME/.parmanode/installed.conf ; then btcpTORmenu=1
echo "#                                    (btcpt)            Tor Server                     #
#                                                                                      #"
elif grep -q "btcpTOR-start" $HOME/.parmanode/installed.conf ; then btcpTORmenu=1
echo "#                                    (btcpt)            Tor Server (partial)           #
#                                                                                      #" ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo "#                                    (specter)          Specter Wallet                 #
#                                                                                      #"
elif grep -q "specter-start" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo "                                     (specter)          Specter Wallet                 #
#                                                                                      #" ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo "#                                    (bre)              BTC RPC Explorer               #
#                                                                                      #"
elif grep -q "btcrpcexplorer-start" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo "#                                    (bre)              BTCrpcEXP (partial)            #
#                                                                                      #" ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo "#                                    (ers)              electrs                        #
#                                                                                      #"
elif grep -q "electrs-start" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo "#                                    (ers)              electrs (partial)              #
#                                                                                      #" ; fi
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo "#                                    (lnb)              LNbits                         #
#                                                                                      #"
elif grep -q "lnbits-start" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo "#                                    (lnb)              LNbits (partial)               #
#                                                                                      #" ; fi
if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo "#                                    (trz)              Trezor Suite                   #
#                                                                                      #"
elif grep -q "trezor-start" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo "#                                    (trz)              Trezor (partial)               #
#                                                                                      #" ; fi
if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo "#                                    (bb)               BitBox                         #
#                                                                                      #"
elif grep -q "bitbox-start" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo "#                                    (bb)               Bitbox  (partial)              #
#                                                                                      #" ; fi
if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo "#                                    (ll)               Ledger                         #
#                                                                                      #"
elif grep -q "ledger-start" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo "#                                    (ll)               Ledger  (partial)              #
#                                                                                      #" ; fi
if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo "#                                    (ps)               Parmashell                     #
#                                                                                      #"
elif grep -q "parmashell-start" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo "#                                    (ps)               Parmashell  (partial)          #
#                                                                                      #" ; fi
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo "#                                    (bre)              BTC RPC Explorer (Docker)      #
#                                                                                      #"
elif grep -q "bre-start" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo "#                                    (bre)              BRE         (partial)          #
#                                                                                      #" ; fi
if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo "#                                    (pbx)              ParmaBox                       #
#                                                                                      #"
elif grep -q "parmabox-start" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo "#                                    (pbx)              Parmabox    (partial)          #
#                                                                                      #" ; fi
if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo "#                                    (any)              AnyDesk                        #
#                                                                                      #"
elif grep -q "anydesk-start" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo "#                                    (any)              AnyDesk     (partial)          #
#                                                                                      #" ; fi
echo "#                                                                                      #
########################################################################################
"
choose "xpmq"
read choice

case $choice in

m) return 0 ;;

parmanode|PARMANODE|Parmanode)
uninstall_parmanode
exit 0
;;

bitcoin|Bitcoin|BITCOIN)
if [[ $bitcoinmenu == 1 ]] ; then
uninstall_bitcoin
return 0
fi
;;

fulcrum|Fulcrum|FULCRUM)
if [[ $fulcrummenu == 1 ]] ; then
uninstall_fulcrum
return 0
fi
;;

docker|Docker|DOCKER)
if [[ $dockermenu == 1 ]] ; then
if [[ $OS == "Mac" ]] ; then uninstall_docker_mac ; fi
if [[ $OS == "Linux" ]] ; then uninstall_docker_linux ; fi
return 0
fi
;;

btcp|BTCP|Btcp)
if [[ $btcpaymenu == 1 ]] ; then
uninstall_btcpay
return 0
fi
;;

TOR|Tor|tor)
if [[ $tormenu == 1 ]] ; then
no_mac || return 1
uninstall_tor
return 0
fi
;;

lnd|LND|Lnd)
if [[ $lndmenu == 1 ]] ; then
if [[ $OS == "Linux" ]] ; then uninstall_lnd ; return 0 ; fi
fi
;;

mem|MEM|Mem)
if [[ $mempoolmenu == 1 ]] ; then
uninstall_mempool
return 0
fi
;;

s|S|SPARROW|Sparrow|sparrow)
if [[ $sparrowmenu == 1 ]] ; then
    uninstall_sparrow
	return 0 
	fi
	;;
R|r|RTL|rtl|Rtl)
if [[ $rtlmenu == 1 ]] ; then
	uninstall_rtl
	return 0
	fi
	;;

e|E|Electrum|electrum|ELECTRUM)
if [[ $electrummenu == 1 ]] ; then
    uninstall_electrum
	return 0
	fi
	;;
ts|TS|Ts)
if [[ $torservermenu == 1 ]] ; then
	no_mac || return 1
	uninstall_tor_server
	return 0
	fi
	;;
btcpt|BTCPT)
if [[ $btcpTORmenu == 1 ]] ; then
	no_mac || return 1
	uninstall_btcpay_tor
	return 0
	fi
    ;;
specter|SPECTER|Specter)
if [[ $spectermenu == 1 ]] ; then
    uninstall_specter
	return 0
	fi
	;;
bre|BRE|Bre)
if [[ $btcrpcexplorermenu == 1 ]] ; then
    uninstall_btcrpcexplorer
	return 0
	fi
if [[ $bredockermenu == 1 ]] ; then
    bre_docker_uninstall
	return 0
	fi
	;;
ers|ERS|Ers|electrs)
if [[ $electrsmenu == 1 ]] ; then
	uninstall_electrs
	return
	fi
	;;
lnb|LNB|Lnb)
if [[ $lnbitsmenu == 1 ]] ; then
	uninstall_lnbits	
	return
	fi
	;;
trz|TRZ|Trz)
if [[ $trezormenu == 1 ]] ; then
	uninstall_trezor
	return
	fi
	;;
bb|BB|Bb)
if [[ $bitboxmenu == 1 ]] ; then
    uninstall_bitbox
	return
	fi
	;;
ll|LL|Ll)
if [[ $ledgermenu == 1 ]] ; then
    uninstall_ledger
	return
	fi
	;;
ps|PS|Ps)
if [[ $parmashellmenu == 1 ]] ; then
uninstall_parmashell
return
fi
;;
pbx|Pbx)
if [[ $parmaboxmenu == 1 ]] ; then
uninstall_parmabox
return
fi
;;
any|ANY|Any)
if [[ $anydeskmenu == 1 ]] ; then
uninstall_anydesk
return
fi
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
