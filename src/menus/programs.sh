function menu_programs {
source $HOME/.parmanode/installed.conf
set_terminal
while true
do
set_terminal_bit_higher
echo "
########################################################################################

                              P A R M A N O D E - \"Apps\"

########################################################################################          

Installed...

"
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (b)       Bitcoin Core
                            " ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (f)       Fulcrum (an Electrum Server)
                            " ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (btcp)    BTCPay Server
                            " ; fi
if grep -q "tor-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (t)       Tor 
                            " ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (lnd)     LND
                            " ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (mem)     Mempool Space 
                            " ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (s)       Sparrow Wallet 
                            " ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then
                       echo "    (r)       RTL Wallet 
                            " ; fi
echo "                            
#######################################################################################
"
choose "xpq"
read choice

case $choice in

b|B)
    clear
    menu_bitcoin_core
    ;;
f|F)
    menu_fulcrum
    ;;
btcp|BTCP)
    if [[ $OS == "Mac" ]] ; then no_mac ; continue ; fi
    menu_btcpay
    ;;

t|T)
    menu_tor
    ;;
lnd|LND|Lnd)
if [[ $OS == "Linux" ]] ; then menu_lnd ; fi
if [[ $OS == "Mac" ]] ; then no_mac ; fi
;;
mem|MEM|Mem)
    menu_mempool
;;

s|S|Sparrow|SPARROW|sparrow)
   menu_sparrow
   ;;
r|R|RTL|rtl|Rtl)
   menu_rtl
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
