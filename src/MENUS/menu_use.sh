function menu_use {
set_terminal
while true
do
unset bitcoinapp fulcrumapp btcpayapp torapp lndapp sparrowapp rtlapp electrumapp 
unset torserverapp btcpTORapp specterapp btcrpcexplorerapp electrsapp lnbitsapp trezorapp bitboxapp
unset ledgerapp parmashellapp parmaboxapp anydeskapp piholeapp torrelayapp
set_terminal_custom 48
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
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then lnbitsapp=1
                       echo "    (lnb)        Lnbits 
                            " ; fi
if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then trezorapp=1
                       echo "    (trz)        Trezor Suite 
                            " ; fi
if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then bitboxapp=1
                       echo "    (bb)         BitBox App 
                            " ; fi
if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then ledgerapp=1
                       echo "    (ll)         Ledger Live App 
                            " ; fi
if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then parmashellapp=1
                       echo "    (ps)         Parmashell
                            " ; fi
if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then parmaboxapp=1
                       echo "    (pbx)        ParmaBox 
                            " ; fi
if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then anydeskapp=1
                       echo "    (any)        AnyDesk 
                            " ; fi
if grep -q "pihole-end" $HOME/.parmanode/installed.conf ; then piholeapp=1
                       echo "    (pih)        PiHole 
                            " ; fi
if grep -q "torrelay-end" $HOME/.parmanode/installed.conf ; then torrelayapp=1
                       echo "    (trl)        Tor Relay 
                            " ; fi
echo "                            

    Add more programs from the 'Add' menu

#######################################################################################
"
if [[ -z $1 ]] ; then
choose "xpmq"
read choice 
else
choice=$1
fi

case $choice in
m|M) back2main ;;

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
    clear
    please_wait
    if [[ $OS == "Linux" ]] ; then menu_lnd ; fi
    if [[ $OS == "Mac" ]] ; then no_mac ; fi
    fi
;;
lnb|LNB|Lnb)
   if [[ $lnbitsapp == 1 ]] ; then
   menu_lnbits
   fi
;;

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
   menu_bre
   fi
   ;;
ers|ERS|Ers)
   if [[ $electrsapp == 1 ]] ; then
   menu_electrs
   fi
   ;;
trz|TRZ|Trz)
   if [[ $trezorapp == 1 ]] ; then
   menu_trezor
   fi
   ;;
bb|BB|Bb)
   if [[ $bitboxapp == 1 ]] ; then
   menu_bitbox
   fi
   ;;
ll|LL|Ll)
   if [[ $ledgerapp == 1 ]] ; then
   menu_ledger
   fi
   ;;
ps|PS|Ps)
   if [[ $parmashellapp == 1 ]] ; then
   parmashell_info
   fi
   ;;
pbx|Pbx)
   if [[ $parmaboxapp == 1 ]] ; then
   menu_parmabox 
   fi
   ;;
any|ANY|Any)
   if [[ $anydeskapp == 1 ]] ; then
   menu_anydesk
   fi
   ;;
pih|PiH|Pih)
   if [[ $piholeapp == 1 ]] ; then
   menu_pihole
   fi
   ;;
trl|Trl|TRL)
   if [[ $torrelayapp == 1 ]] ; then
   menu_torrelay
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
   if [[ -n $1 ]] ; then return 1 ; fi
   ;;
esac

if [[ -n $1 ]] ; then return 1 ; fi
done
}
