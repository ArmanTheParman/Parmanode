function menu_use {

while true ; do
unset count
unset raidapp
unset bitcoinapp fulcrumapp fulcrumdkrapp btcpayapp torapp lndapp sparrowapp rtlapp electrumapp 
unset torserverapp specterapp btcrpcexplorerapp electrsapp lnbitsapp trezorapp bitboxapp
unset ledgerapp parmashellapp parmaviewapp parmaboxapp anydeskapp piholeapp torrelayapp
unset electrsdkrapp torbapp qbittorrentapp mempoolapp torsshapp public_poolapp
unset electrumxapp thunderhubapp websiteapp lnddockerapp nostrrelay litdapp parmacloudapp
unset parmanostrapp btcrecoverapp joinmarketapp greenapp parman_booksapp X11app phoenixapp
unset parminerapp parmanasapp parmascaleapp vaultwardenapp

set_terminal 36 88
echo -e "
########################################################################################

     P A R M A N O D E --> Main Menu --> ${cyan}USE (installed)$orange                               

########################################################################################          

"
### Premium
if grep -q "parmadrive-end" $ic ; then
                       echo -e "                   $cyan       pdrive)$blue     ParmaDrive$orange" ; parmadriveapp=1 ; count=$((count +1)) ; fi
if grep -q "parmaplex-end" $ic ; then 
                       echo -e "                   $cyan       plex)$blue       ParmaPlex Media Server$orange" ; parmanpremiumapp=1 ; count=$((count +1)) ; fi
if grep -q "parmanas-end" $ic ; then 
                       echo -e "                   $cyan       pnas)$blue       ParmaNas$orange" ; parmanasapp=1 ; count=$((count +1)) ; fi
if grep -q "parmascale-end" $ic ; then
                       echo -e "                   $cyan       scale)$blue      ParmaScale$orange" ; parmascaleapp=1 ; count=$((count +1)) ; fi
if [[ -e $pp/datum ]] ; then 
                       echo -e "                   $cyan       dt)$blue         Datum$orange" ; datumapp=1 ; count=$((count +1)) ; fi
if [[ -e $pp/uddns ]] ; then 
                       echo -e "                   $cyan       ud)$blue         UDDNS$orange" ; uddnsapp=1 ; count=$((count +1)) ; fi
if  grep -q "parmasync-end" $ic ; then
                       echo -e "                        $cyan  sync)$blue       ParmaSync$orange" ; parmasyncapp=1 ; count=$((count +1)) ; fi
if grep -q "parmatwin-end" $ic ; then 
                       echo -e "                        $cyan  twin)$blue       ParmaTwin Server$orange" ; parmatwinapp=1 ; count=$((count +1)) ; fi
if grep -q "parmacloud-end" $ic ; then parmacloudapp=1
                       echo -e "                        $cyan  cloud)$blue      ParmaCloud$orange" ; count=$((count +1)) ; fi
if grep -q "website-end" $ic ; then websiteapp=1
                       echo -e "                        $cyan  pw)$blue         WordPress Website (ParmaWeb)$orange" ; count=$((count +1)) ; fi
if grep -q "parmaraid-end" $ic ; then raidapp=1
                       echo -e "                   $cyan       rr)$blue         RAID" ; count=$((count +1)) ; fi
if grep -q "parmasql-end" $ic ; then parmasqlapp=1
                       echo -e "                        $cyan  psql)$blue       ParmaSQL" ; count=$((count +1)) ; fi
### Bitcoin 
if grep -q "bitcoin-end" $ic ; then bitcoinapp=1
                       echo -e "                        $cyan  b)$orange          Bitcoin " ; count=$((count +1)) ; fi
### Databases
if grep -q "electrs-end" $ic ; then electrsapp=1
                       echo -e "                        $cyan  ers)$orange        electrs " ; count=$((count +1)) ; fi
if grep -q "electrsdkr-end" $ic ; then electrsdkrapp=1
                       echo -e "                        $cyan  ersd)$orange       electrs (Docker) " ; count=$((count +1)) ; fi
if grep -q "electrumx-end" $ic ; then electrumxapp=1
                       echo -e "                        $cyan  ex)$orange         Electrum X " ; count=$((count +1)) ; fi
if grep -q "fulcrum-end" $ic ; then fulcrumapp=1
                       echo -e "                        $cyan  f)$orange          Fulcrum (an Electrum Server) " ; count=$((count +1)) ; fi
if grep -q "fulcrumdkr-end" $ic ; then fulcrumdkrapp=1
                       echo -e "                        $cyan  fd)$orange         Fulcrum (an Electrum Server in Docker) " ; count=$((count +1)) ; fi
if grep -q "mempool-end" $ic ; then mempoolapp=1
                       echo -e "                        $cyan  mem)$orange        Mempool " ; count=$((count +1)) ; fi
if grep -q "bre-end" $ic ; then breapp=1
                       echo -e "                        $cyan  bre)$orange        BTC RPC Explorer (Docker) " ; count=$((count +1)) ; fi
if grep -q "btcrpcexplorer-end" $ic ; then btcrpcexplorerapp=1
                       echo -e "                        $cyan  bre)$orange        BTC RPC Explorer " ; count=$((count +1)) ; fi
#### Wallets                     
if grep -q "sparrow-end" $ic ; then sparrowapp=1
                       echo -e "                        $cyan  s)$orange          Sparrow Wallet " ; count=$((count +1)) ; fi
if grep -q "electrum-end" $ic ; then electrumapp=1
                       echo -e "                        $cyan  e)$orange          Electrum Wallet " ; count=$((count +1)) ; fi
if grep -q "specter-end" $ic ; then specterapp=1
                       echo -e "                        $cyan  specter)$orange    Specter Wallet " ; count=$((count +1)) ; fi
if grep -q "trezor-end" $ic ; then trezorapp=1
                       echo -e "                        $cyan  trz)$orange        Trezor Suite " ; count=$((count +1)) ; fi
if grep -q "bitbox-end" $ic ; then bitboxapp=1
                       echo -e "                        $cyan  bb)$orange         BitBox App " ; count=$((count +1)) ; fi
if grep -q "ledger-end" $ic ; then ledgerapp=1
                       echo -e "                        $cyan  ll)$orange         Ledger Live App " ; count=$((count +1)) ; fi
if grep -q "green-end" $ic ; then greenapp=1
                       echo -e "                        $cyan  gr)  $orange       Green Wallet " ; count=$((count +1)) ; fi
if grep -q "btcrecover-end" $ic ; then btcrecoverapp=1
                       echo -e "                        $cyan  btcr)  $orange     BTC Recover " ; count=$((count +1)) ; fi
if grep -q "joinmarket-end" $ic ; then joinmarketapp=1
                       echo -e "                        $cyan  join)  $orange     JoinMarket " ; count=$((count +1)) ; fi
if grep -q "parmanostr-end" $ic ; then parmanostrapp=1
                       echo -e "                        $cyan  pnostr)$orange     ParmaNostr " ; count=$((count +1)) ; fi
### Lightning related 
if grep -q "lnd-end" $ic ; then lndapp=1
                       echo -e "                        $cyan  l)$orange          LND " ; count=$((count +1)) ; fi
if grep -q "lnddocker-end" $ic ; then lnddockerapp=1
                       echo -e "                        $cyan  ld)$orange         LND (Docker) " ; count=$((count +1)) ; fi
if grep -q "btcpay-end" $ic ; then btcpayapp=1
                       echo -e "                        $cyan  btcp)$orange       BTCPay Server " ; count=$((count +1)) ; fi
if grep -q "rtl-end" $ic ; then rtlapp=1
                       echo -e "                        $cyan  r)$orange          RTL Wallet " ; count=$((count +1)) ; fi
if grep -q "thunderhub-end" $ic ; then thunderhubapp=1
                       echo -e "                        $cyan  th)$orange         Thunderhub " ; count=$((count +1)) ; fi
if grep -q "lnbits-end" $ic ; then lnbitsapp=1
                       echo -e "                        $cyan  lnb)$orange        Lnbits " ; count=$((count +1)) ; fi
if grep -q "litd-end" $ic ; then litdapp=1
                       echo -e "                        $cyan  litd)$orange       LITD "
                       echo -e "                        $cyan  lt)$orange         Lightning Terminal " ; count=$((count +1)) ; fi
if grep -q "phoenix-end" $ic ; then phoenixapp=1
                       echo -e "                        $cyan  pho)  $orange      Phoenix Server " ; count=$((count +1)) ; fi
### Mining
if grep -q "public_pool-end" $ic ; then public_poolapp=1
                       echo -e "                        $cyan  pool)$orange       Public Pool " ; count=$((count +1)) ; fi
### General
if grep -q "parmaview-end" $ic ; then parmaviewapp=1
                       echo -e "                        $cyan  pv)$orange         ParmaView" ; count=$((count +1)) ; fi
if grep -q "parmashell-end" $ic ; then parmashellapp=1
                       echo -e "                        $cyan  ps)$orange         Parmashell " ; count=$((count +1)) ; fi
if grep -q "anydesk-end" $ic ; then anydeskapp=1
                       echo -e "                        $cyan  any)$orange        AnyDesk " ; count=$((count +1)) ; fi
if grep -q "pihole-end" $ic ; then piholeapp=1
                       echo -e "                        $cyan  pih)$orange        PiHole " ; count=$((count +1)) ; fi
if grep -q "parmabox-end" $ic ; then parmaboxapp=1
                       echo -e "                        $cyan  pbx)$orange        ParmaBox " ; count=$((count +1)) ; fi
if grep -q "nostrrelay-end" $ic ; then nostrrelayapp=1
                       echo -e "                        $cyan  nr)$orange         Nostr Relay " ; count=$((count +1)) ; fi
if grep -q "X11-end" $ic ; then X11app=1
                       echo -e "                        $cyan  x11)  $orange      X11 Forwarding " ; count=$((count +1)) ; fi
if grep -q "nginx-end" $ic ; then nginxapp=1
                       echo -e "                        $cyan  ng)  $orange       Nginx " ; count=$((count +1)) ; fi
if grep -q "vaultwarden-end" $ic ; then vaultwardenapp=1
                       echo -e "                        $cyan  vw)  $orange       VaultWarden" ; count=$((count +1)) ; fi
### Education
if [[ -d $hp/parman_books ]] ; then parman_booksapp=1
                       echo -e "                        $cyan  pb)  $orange       ParmaBooks " ; count=$((count +1)) ; fi
### Privacy related 
if which tor >$dn 2>&1 ; then torapp=1
                       echo -e "                        $cyan  t)$orange          Tor " ; count=$((count +1)) ; fi
if grep -q "tor-server-end" $ic ; then torserverapp=1
                       echo -e "                        $cyan  tws)$orange        Tor Web Server " ; count=$((count +1)) ; fi
if grep -q "torrelay-end" $ic ; then torrelayapp=1
                       echo -e "                        $cyan  trl)$orange        Tor Relay " ; count=$((count +1)) ; fi
if grep -q "torb-end" $ic ; then torbapp=1
                       echo -e "                        $cyan  torb)$orange       Tor Browser " ; count=$((count +1)) ; fi
if grep -q "qbittorrent-end" $ic ; then qbittorrentapp=1
                       echo -e "                        $cyan  qbit)$orange       QBittorrent " ; count=$((count +1)) ; fi
if grep -q "torssh-end" $ic ; then torsshapp=1
                       echo -e "                        $cyan  tssh)$orange       Tor SSH " ; count=$((count +1)) ; fi
if grep -q "nym-end" $ic ; then nymapp=1
                       echo -e "                        $cyan  nym)$orange        Nym VPN " ; count=$((count +1)) ; fi
if grep -q "i2p-end" $ic ; then i2papp=1
                       echo -e "                        $cyan  ii)$orange         I2P "     ; count=$((count +1)) ; fi
if grep -q "parmadesk-end" $ic ; then parmadeskapp=1
                       echo -e "                        $cyan  pd)$orange         ParmaDesk VNC" ; count=$((count +1)) ; fi
echo -e "                            
#######################################################################################
"
parmanode_conf_remove "usecount"
parmanode_conf_add "usecount=$count"
if [[ -z $1 ]] ; then
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
else
choice=$1
fi

case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
rr)
    if [[ $raidapp == 1 ]] ; then
    clear
    menu_parmaraid
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
fd|FD)
    if [[ $fulcrumdkrapp == 1 ]] ; then
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
    else 
        invalid
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
   if [[ $electrsapp == 1 ]] ; then
   menu_electrs
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

ersf|ERSf|Ersf)
   if [[ $electrsapp == 1 ]] ; then
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
pv|pview)
   if [[ $parmaviewapp == 1 ]] ; then
   menu_parmaview 
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
   if [[ $electrsdkrapp == 1 ]] ; then
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
nym)
   if [[ $nymapp == 1 ]] ; then
   menu_nym
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
ii|i2p)
   if [[ $i2papp == 1 ]] ; then
   menu_i2p
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
pd|vnc)
   if [[ $parmadeskapp == 1 ]] ; then
   menu_parmadesk
    if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

# pool)
#    if [[ $public_poolapp == 1 ]] ; then
#    menu_public_pool
#     if [[ -n $1 ]] ; then clear ; return 0 ; fi
#    else invalid
#    fi
#    ;;

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
pw) 
   if [[ $websiteapp == 1 ]] ; then
   menu_parmaweb
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

X11|x11)
   if [[ $X11app == 1 ]] ; then
   menu_X11
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
vw)
   if [[ $vaultwardenapp == 1 ]] ; then
   menu_vaultwarden
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

nginx|ng)
  if [[ $nginxapp == 1 ]] ; then
  menu_nginx
  if [[ -n $1 ]] ; then clear ; return 0 ; fi
  else invalid
  fi
  ;;

pb)
if [[ $parman_booksapp == 1 ]] ; then
menu_parmabooks
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

pho)
if [[ $phoenixapp == 1 ]] ; then
menu_phoenix
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

pm)
if [[ $parminerapp == 1 ]] ; then
please_wait
cd $pp/parminer/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
source_premium
$pp/parminer/run_parminer.sh
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

dt)
if [[ $datumapp == 1 ]] ; then
please_wait
cd $pp/datum/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
source_premium
menu_datum
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

ud)
if [[ $uddnsapp == 1 ]] ; then
please_wait
cd $pp/uddns/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
source_premium
menu_uddns
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

pdrive)
if [[ $parmadriveapp == 1 ]] ; then
please_wait
cd $pp/parmadrive/ 2>$dn && git stash >$dn 2>&1 && git pull >$dn 2>&1
source_premium
menu_parmadrive
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

pnas)
if [[ $parmanasapp == 1 ]] ; then
please_wait
cd $pp/parmanas/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
source_premium
$pp/parmanas/run_parmanas.sh
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

scale)
if [[ $parmascaleapp == 1 ]] ; then
please_wait
cd $pp/parmascale/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
source_premium
menu_parmascale
if [[ -n $1 ]] ; then clear ; return 0 ; fi
else invalid
fi
;;

cloud) 
   if [[ $parmacloudapp == 1 ]] ; then
   menu_parmacloud
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;

sync) 
   if [[ $parmasyncapp == 1 ]] ; then
   please_wait
   cd $pp/parmasync/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
   source_premium
   menu_parmasync
   debug "after menu_parmasync"
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
twin) 
   if [[ $parmatwinapp == 1 ]] ; then
   please_wait
   cd $pp/parmasync/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
   source_premium
   menu_parmatwin
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
psql) 
   if [[ $parmasqlapp == 1 ]] ; then
   please_wait
   cd $pp/parmasql/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
   source_premium
   menu_parmasql
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
   ;;
plex) 
   if [[ $parmanpremiumapp == 1 ]] ; then
   please_wait
   cd $pp/parmanpremium/ && git stash >$dn 2>&1 ; git pull >$dn 2>&1
   source_premium
   menu_parmaplex
   if [[ -n $1 ]] ; then clear ; return 0 ; fi
   else invalid
   fi
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
