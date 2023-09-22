function menu_programs {
set_terminal
while true
do
set_terminal_bit_higher
echo -e "
########################################################################################

     P A R M A N O D E --> Main Menu --> ${cyan}\"Apps\"$orange                               

########################################################################################          

Installed...

"
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinapp=1
                       echo "    (b)          Bitcoin Core
                            " ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrumapp=1
                       echo "    (f)          Fulcrum (an Electrum Server)
                            " ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpayapp=1
                       echo "    (btcp)       BTCPay Server
                            " ; fi
if which tor >/dev/null 2>&1 ; then torapp=1
                       echo "    (t)          Tor 
                            " ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndapp=1
                       echo "    (l)          LND
                            " ; fi
# if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolapp=1
#                        echo "    (mem)        Mempool Space 
#                             " ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowapp=1
                       echo "    (s)          Sparrow Wallet 
                            " ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtlapp=1
                       echo "    (r)          RTL Wallet 
                            " ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrumapp=1
                       echo "    (e)          Electrum Wallet 
                            " ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torserverapp=1
                       echo "    (ts)         Tor Server 
                            " ; fi
if grep -q "btcpTOR-end" $HOME/.parmanode/installed.conf ; then btcpTORapp=1
                       echo "    (btcpt)      BTCPay over Tor 
                            " ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then specterapp=1
                       echo "    (specter)    Specter Wallet 
                            " ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexplorerapp=1
                       echo "    (bre)        BTC RPC Explorer 
                            " ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsapp=1
                       echo "    (ers)        electrs 
                            " ; fi
echo "                            
#######################################################################################
"
choose "xpq"

read choice

case $choice in

b|B)
    if [[ $bitcoinapp == 1 ]] ; then
    clear
    menu_bitcoin_core
    fi
    ;;
f|F)
    if [[ $fulcrumapp == 1 ]] ; then
    menu_fulcrum
    fi
    ;;
btcp|BTCP)
    if [[ $btcpayapp == 1 ]] ; then
    if [[ $OS == "Mac" ]] ; then no_mac ; continue ; fi
    menu_btcpay
    fi
    ;;

t|T)
    if [[ $torapp == 1 ]] ; then
    menu_tor
    fi
    ;;

lnd|LND|Lnd|L|l)
    if [[ $lndapp == 1 ]] ; then
    if [[ $OS == "Linux" ]] ; then menu_lnd ; fi
    if [[ $OS == "Mac" ]] ; then no_mac ; fi
    fi
;;
# mem|MEM|Mem)
#    if [[ $mempoolapp == 1 ]] ; then
#    menu_mempool
#    fi
# ;;

s|S|Sparrow|SPARROW|sparrow)
   if [[ $sparrowapp == 1 ]] ; then
   menu_sparrow
   fi
   ;;
r|R|RTL|rtl|Rtl)
    if [[ $rtlapp == 1 ]] ; then
   menu_rtl
   fi
   ;;

e|E|Electrum|electrum|ELECTRUM)
    if [[ $electrumapp == 1 ]] ; then
   menu_electrum
   fi
   ;;
ts|TS|Ts)

   if [[ $torserverapp == 1 ]] ; then
   menu_tor_server
   fi
   ;;
btcpt|BTCPT)
   if [[ $btcpTORapp == 1 ]] ; then
   menu_btcpay_tor
   fi
   ;;

specter|SPECTER|Specter)
   if [[ $specterapp == 1 ]] ; then
   menu_specter
   fi
   ;;

bre|BRE|Bre)
   if [[ $btcrpcexplorerapp == 1 ]] ; then
   menu_btcrpcexplorer 
   fi
   ;;
ers|ERS|Ers)
   if [[ $electrsapp == 1 ]] ; then
   menu_electrs
   fi
   ;;

p)
   return 0
   ;;
q | Q | quit)
   exit 0
   ;;
*)
   invalid
   ;;
esac

done
}
