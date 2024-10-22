function menu_use {
set_terminal
while true
do
unset raidapp
unset bitcoinapp fulcrumapp btcpayapp torapp lndapp sparrowapp rtlapp electrumapp 
unset torserverapp specterapp btcrpcexplorerapp electrsapp lnbitsapp trezorapp bitboxapp
unset ledgerapp parmashellapp parmaboxapp anydeskapp piholeapp torrelayapp
unset electrsdkrapp electrsdkr2app torbapp qbittorrentapp mempoolapp torsshapp public_poolapp
unset electrumxapp thunderhubapp websiteapp lnddockerapp nostrrelay litdapp nextcloudapp
unset parmanostrapp 
set_terminal_custom 48
echo -e "
########################################################################################

     P A R M A N O D E --> Main Menu --> ${cyan}USE (installed)$orange                               

########################################################################################          


"
if grep -q "/dev/md" $ic ; then raidapp=1
                       echo -e "                   $cyan       (rr)$orange         RAID 
                            " ; fi
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinapp=1
                       echo -e "                        $cyan  (b)$orange          Bitcoin Core
                            " ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrumapp=1
                       echo -e "                        $cyan  (f)$orange          Fulcrum (an Electrum Server)
                            " ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpayapp=1
                       echo -e "                        $cyan  (btcp)$orange       BTCPay Server
                            " ; fi
if which tor >/dev/null 2>&1 ; then torapp=1
                       echo -e "                        $cyan  (t)$orange          Tor 
                            " ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndapp=1
                       echo -e "                        $cyan  (l)$orange          LND
                            " ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowapp=1
                       echo -e "                        $cyan  (s)$orange          Sparrow Wallet 
                            " ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtlapp=1
                       echo -e "                        $cyan  (r)$orange          RTL Wallet 
                            " ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrumapp=1
                       echo -e "                        $cyan  (e)$orange          Electrum Wallet 
                            " ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torserverapp=1
                       echo -e "                        $cyan  (tws)$orange        Tor Web Server 
                            " ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then specterapp=1
                       echo -e "                        $cyan  (specter)$orange    Specter Wallet 
                            " ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexplorerapp=1
                       echo -e "                        $cyan  (bre)$orange        BTC RPC Explorer 
                            " ; fi
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then breapp=1
                       echo -e "                        $cyan  (bre)$orange        BTC RPC Explorer (Docker)
                            " ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsapp=1
                       echo -e "                        $cyan  (ers)$orange        electrs 
                            " ; fi
if grep -q "electrs2-end" $HOME/.parmanode/installed.conf ; then electrs2app=1
                       echo -e "                        $cyan  (ers)$orange        electrs 
                            " ; fi
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then lnbitsapp=1
                       echo -e "                        $cyan  (lnb)$orange        Lnbits 
                            " ; fi
if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then trezorapp=1
                       echo -e "                        $cyan  (trz)$orange        Trezor Suite 
                            " ; fi
if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then bitboxapp=1
                       echo -e "                        $cyan  (bb)$orange         BitBox App 
                            " ; fi
if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then ledgerapp=1
                       echo -e "                        $cyan  (ll)$orange         Ledger Live App 
                            " ; fi
if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then parmashellapp=1
                       echo -e "                        $cyan  (ps)$orange         Parmashell
                            " ; fi
if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then parmaboxapp=1
                       echo -e "                        $cyan  (pbx)$orange        ParmaBox 
                            " ; fi
if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then anydeskapp=1
                       echo -e "                        $cyan  (any)$orange        AnyDesk 
                            " ; fi
if grep -q "pihole-end" $HOME/.parmanode/installed.conf ; then piholeapp=1
                       echo -e "                        $cyan  (pih)$orange        PiHole 
                            " ; fi
if grep -q "torrelay-end" $HOME/.parmanode/installed.conf ; then torrelayapp=1
                       echo -e "                        $cyan  (trl)$orange        Tor Relay 
                            " ; fi
if grep -q "electrsdkr-end" $HOME/.parmanode/installed.conf ; then electrsdkrapp=1
                       echo -e "                        $cyan  (ersd)$orange       electrs (Docker)
                            " ; fi
if grep -q "electrsdkr2-end" $HOME/.parmanode/installed.conf ; then electrsdkr2app=1
                       echo -e "                        $cyan  (ersd)$orange       electrs (Docker)
                            " ; fi
if grep -q "torb-end" $HOME/.parmanode/installed.conf ; then torbapp=1
                       echo -e "                        $cyan  (torb)$orange       Tor Browser
                            " ; fi
if grep -q "qbittorrent-end" $HOME/.parmanode/installed.conf ; then qbittorrentapp=1
                       echo -e "                        $cyan  (qbit)$orange       QBittorrent 
                            " ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolapp=1
                       echo -e "                        $cyan  (mem)$orange        Mempool 
                            " ; fi
if grep -q "torssh-end" $HOME/.parmanode/installed.conf ; then torsshapp=1
                       echo -e "                        $cyan  (tssh)$orange       Tor SSH 
                            " ; fi
if grep -q "public_pool-end" $HOME/.parmanode/installed.conf ; then public_poolapp=1
                       echo -e "                        $cyan  (pool)$orange       Public Pool 
                            " ; fi
if grep -q "electrumx-end" $HOME/.parmanode/installed.conf ; then electrumxapp=1
                       echo -e "                        $cyan  (ex)$orange         Electrum X 
                            " ; fi
if grep -q "thunderhub-end" $HOME/.parmanode/installed.conf ; then thunderhubapp=1
                       echo -e "                        $cyan  (th)$orange         Thunderhub 
                            " ; fi
if grep -q "website-end" $HOME/.parmanode/installed.conf ; then websiteapp=1
                       echo -e "                        $cyan  (ws)$orange         WordPress Website 
                            " ; fi
if grep -q "lnddocker-end" $HOME/.parmanode/installed.conf ; then lnddockerapp=1
                       echo -e "                        $cyan  (ld)$orange         LND (Docker)
                            " ; fi
if grep -q "nostrrelay-end" $HOME/.parmanode/installed.conf ; then nostrrelayapp=1
                       echo -e "                        $cyan  (nr)$orange         Nostr Relay
                            " ; fi
if grep -q "litd-end" $HOME/.parmanode/installed.conf ; then litdapp=1
                       echo -e "                        $cyan  (litd)$orange       LITD
                       "
                       echo -e "                        $cyan  (lt)$orange         Lightning Terminal
                            " ; fi
if grep -q "nextcloud-end" $HOME/.parmanode/installed.conf ; then nextcloudapp=1
                       echo -e "                        $cyan  (next)$orange       NextCloud
                            " ; fi
if grep -q "parmanostr-end" $HOME/.parmanode/installed.conf ; then parmanostrapp=1
                       echo -e "                        $cyan  (pnostr)$orange     ParmaNostr 
                            " ; fi
if grep -q "btcrecover-end" $HOME/.parmanode/installed.conf ; then btcrecoverapp=1
                       echo -e "                        $cyan  (btcr)  $orange     BTC Recover
                            " ; fi
if grep -q "joinmarket-end" $HOME/.parmanode/installed.conf ; then joinmarketapp=1
                       echo -e "                        $cyan  (join)  $orange     JoinMarket
                            " ; fi
if grep -q "green-end" $HOME/.parmanode/installed.conf ; then greenapp=1
                       echo -e "                        $cyan  (gr)  $orange       Green Wallet
                            " ; fi
echo -e "                            
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

rr)
    if [[ $raidapp == 1 ]] ; then
    clear
    menu_raid
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
    ;;

b|B)
    if [[ $bitcoinapp == 1 ]] ; then
    clear
    menu_bitcoin
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
    ;;
f|F)
    if [[ $fulcrumapp == 1 ]] ; then
    menu_fulcrum
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
    ;;
btcp|BTCP)
    if [[ $btcpayapp == 1 ]] ; then
    menu_btcpay
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
    ;;

tor|TOR|t|T)
    if [[ $torapp == 1 ]] ; then
    menu_tor
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
    ;;

lnd|LND|Lnd|L|l)
    if [[ $lndapp == 1 ]] ; then
    clear
    please_wait
      if [[ $OS == "Linux" ]] ; then menu_lnd ; continue ; fi
      if [[ $OS == "Mac" ]] ; then no_mac ; continue ; fi
      if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid 
    fi
;;
ld|LD|Ld|lD)
    if [[ $lnddockerapp == 1 ]] ; then
    clear
    please_wait
    menu_lnd
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
    else invalid
    fi
;;
lnb|LNB|Lnb)
   if [[ $lnbitsapp == 1 ]] ; then
   menu_lnbits
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
;;

s|S|Sparrow|SPARROW|sparrow)
   if [[ $sparrowapp == 1 ]] ; then
   menu_sparrow
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
r|R|RTL|rtl|Rtl)
    if [[ $rtlapp == 1 ]] ; then
   menu_rtl
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

e|E|Electrum|electrum|ELECTRUM)
   if [[ $electrumapp == 1 ]] ; then
   menu_electrum
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
tws|TWS|Tws)

   if [[ $torserverapp == 1 ]] ; then
   menu_tor_webserver
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

specter|SPECTER|Specter)
   if [[ $specterapp == 1 ]] ; then
   menu_specter
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

bre|BRE|Bre)
   if [[ $btcrpcexplorerapp == 1 || $breapp ]] ; then
   menu_bre
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

ers|ERS|Ers)
   if [[ $electrsapp == 1 || $electrs2app == 1 ]] ; then
   menu_electrs
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

ersf|ERSf|Ersf)
   if [[ $electrsapp == 1 || $electrs2app == 1 ]] ; then
   menu_electrs fast
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
trz|TRZ|Trz)
   if [[ $trezorapp == 1 ]] ; then
   menu_trezor
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
bb|BB|Bb)
   if [[ $bitboxapp == 1 ]] ; then
   menu_bitbox
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
ll|LL|Ll)
   if [[ $ledgerapp == 1 ]] ; then
   menu_ledger
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
ps|PS|Ps)
   if [[ $parmashellapp == 1 ]] ; then
   parmashell_info
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
pbx|Pbx)
   if [[ $parmaboxapp == 1 ]] ; then
   menu_parmabox 
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
any|ANY|Any)
   if [[ $anydeskapp == 1 ]] ; then
   menu_anydesk
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
pih|PiH|Pih)
   if [[ $piholeapp == 1 ]] ; then
   menu_pihole
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
trl|Trl|TRL)
   if [[ $torrelayapp == 1 ]] ; then
   menu_torrelay
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
ersd|Ersd|ERSD)
   if [[ $electrsdkrapp == 1 || $electrsdkr2app == 1 ]] ; then
   menu_electrs
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
torb|TORB|Torb)
   if [[ $torbapp == 1 ]] ; then
   menu_torbrowser
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
qbit|Qbit)
   if [[ $qbittorrentapp == 1 ]] ; then
   menu_qbittorrent
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
mem|MEM|Mem)
   if [[ $mempoolapp == 1 ]] ; then
   menu_mempool 
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
tssh)
   if [[ $torsshapp == 1 ]] ; then
   menu_torssh
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
pool)
   if [[ $public_poolapp == 1 ]] ; then
   menu_public_pool
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

ex)
   if [[ $electrumxapp == 1 ]] ; then
   menu_electrumx
   debug "after menu_electrumx"
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
th) 
   if [[ $thunderhubapp == 1 ]] ; then
   menu_thunderhub
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
ws) 
   if [[ $websiteapp == 1 ]] ; then
   menu_website
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
nr) 
   if [[ $nostrrelayapp == 1 ]] ; then
   menu_nostr
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
litd) 
   if [[ $litdapp == 1 ]] ; then
   menu_lnd
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
lt)
   if [[ $litdapp == 1 ]] ; then
   menu_litterminal
   else invalid
   fi
   ;;
next) 
   if [[ $nextcloudapp == 1 ]] ; then
   menu_nextcloud
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
pnostr) 
   if [[ $parmanostrapp == 1 ]] ; then
   menu_parmanostr
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
btcr) 
   if [[ $btcrecoverapp == 1 ]] ; then
   menu_btcrecover
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
join) 
   if [[ $joinmarketapp == 1 ]] ; then
   menu_joinmarket
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
gr|green)
   if [[ $greenapp == 1 ]] ; then
   menu_green
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

######Hidden Menu########
ng)
  if which nginx >/dev/null 2>&1 ; then
  menu_nginx
  fi
  ;;
##########################
p)
   menu_main 
   ;;
q | Q | quit)
   exit 0
   ;;
*)
   invalid
   clear
   if [[ -n $1 ]] ; then clear ; return 1 ; fi
   ;;
esac

if [[ -n $1 ]] ; then clear ; return 1 ; fi
done
}
