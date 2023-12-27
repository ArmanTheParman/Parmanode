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
                       echo "    (tws)        Tor Web Server 
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
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then breapp=1
                       echo "    (bre)        BTC RPC Explorer (Docker)
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
if grep -q "electrsdkr-end" $HOME/.parmanode/installed.conf ; then electrsdkrapp=1
                       echo "    (ersd)       electrs (Docker) 
                            " ; fi
if grep -q "torb-end" $HOME/.parmanode/installed.conf ; then torbapp=1
                       echo "    (torb)       Tor Browser
                            " ; fi
if grep -q "qbittorrent-end" $HOME/.parmanode/installed.conf ; then qbittorrentapp=1
                       echo "    (qbit)       QBittorrent 
                            " ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolapp=1
                       echo "    (mem)        Mempool 
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
    menu_bitcoin
    if [[ -n $1 ]] ; then return 0 ; fi
    fi
    ;;
f|F)
    if [[ $fulcrumapp == 1 ]] ; then
    menu_fulcrum
    if [[ -n $1 ]] ; then return 0 ; fi
    fi
    ;;
btcp|BTCP)
    if [[ $btcpayapp == 1 ]] ; then
    if [[ $OS == "Mac" ]] ; then no_mac ; return 1 ; fi
    menu_btcpay
    if [[ -n $1 ]] ; then return 0 ; fi
    fi
    ;;

t|T)
    if [[ $torapp == 1 ]] ; then
    menu_tor
    if [[ -n $1 ]] ; then return 0 ; fi
    fi
    ;;

lnd|LND|Lnd|L|l)
    if [[ $lndapp == 1 ]] ; then
    clear
    please_wait
    if [[ $OS == "Linux" ]] ; then menu_lnd ; continue ; fi
    if [[ $OS == "Mac" ]] ; then no_mac ; continue ; fi
    if [[ -n $1 ]] ; then return 0 ; fi
    fi
;;
lnb|LNB|Lnb)
   if [[ $lnbitsapp == 1 ]] ; then
   menu_lnbits
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
;;

s|S|Sparrow|SPARROW|sparrow)
   if [[ $sparrowapp == 1 ]] ; then
   menu_sparrow
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
r|R|RTL|rtl|Rtl)
    if [[ $rtlapp == 1 ]] ; then
   menu_rtl
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;

e|E|Electrum|electrum|ELECTRUM)
    if [[ $electrumapp == 1 ]] ; then
   menu_electrum
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
tws|TWS|Tws)

   if [[ $torserverapp == 1 ]] ; then
   menu_tor_webserver
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
btcpt|BTCPT)
   if [[ $btcpTORapp == 1 ]] ; then
   menu_btcpay_tor
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;

specter|SPECTER|Specter)
   if [[ $specterapp == 1 ]] ; then
   menu_specter
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;

bre|BRE|Bre)
   if [[ $btcrpcexplorerapp == 1 || $breapp ]] ; then
   menu_bre
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;

ers|ERS|Ers)
   if [[ $electrsapp == 1 ]] ; then
   menu_electrs
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
trz|TRZ|Trz)
   if [[ $trezorapp == 1 ]] ; then
   menu_trezor
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
bb|BB|Bb)
   if [[ $bitboxapp == 1 ]] ; then
   menu_bitbox
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
ll|LL|Ll)
   if [[ $ledgerapp == 1 ]] ; then
   menu_ledger
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
ps|PS|Ps)
   if [[ $parmashellapp == 1 ]] ; then
   parmashell_info
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
pbx|Pbx)
   if [[ $parmaboxapp == 1 ]] ; then
   menu_parmabox 
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
any|ANY|Any)
   if [[ $anydeskapp == 1 ]] ; then
   menu_anydesk
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
pih|PiH|Pih)
   if [[ $piholeapp == 1 ]] ; then
   menu_pihole
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
trl|Trl|TRL)
   if [[ $torrelayapp == 1 ]] ; then
   menu_torrelay
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
ersd|Ersd|ERSD)
   if [[ $electrsdkrapp == 1 ]] ; then
   menu_electrs_docker
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
torb|TORB|Torb)
   if [[ $torbapp == 1 ]] ; then
   menu_torbrowser
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
qbit|Qbit)
   if [[ $qbittorrentapp == 1 ]] ; then
   menu_qbittorrent
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
mem|MEM|Mem)
   if [[ $mempoolapp == 1 ]] ; then
   menu_mempool 
    if [[ -n $1 ]] ; then return 0 ; fi
   fi
   ;;
p)
   menu_main 
   ;;
q | Q | quit)
   exit 0
   ;;
*)
   invalid
   clear
   if [[ -n $1 ]] ; then return 1 ; fi
   ;;
esac

if [[ -n $1 ]] ; then return 1 ; fi
done
}
