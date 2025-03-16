function menu_remove {
# another dynamic menu. Each program is listed either as available to be removed, 
# or as a partial (failed) installation, that can be removed. The menu variable is 
# set to toggle the availability of the menu logic below, via if statements.

while true ; do
clear
local num1=$(cat $dp/installed.conf | wc -l)
local num=$(( 42 + ((num1)/2 - 14) ))
if [[ $num -lt 45 ]] ; then num=46 ; fi
if [[ $num -gt 66 ]] ; then num=66 ; fi
set_terminal_custom $((num + 2))
unset bitcoinmenu fulcrummenu dockermenu btcpaymenu lnbitsmenu tormenu lndmenu mempoolmenu 
unset sparrowmenu rtlmenu electrummenu torservermenu btcTORmenu spectermenu btcrpcexplorermenu
unset electrsmenu trezormenu ledgermenu bitboxmenu parmashellmenu bredockermenu parmaboxmenu
unset anydeskmenu piholemenu torrelaymenu electrskdmenu piappsmenu torbmenu electrs2menu electrsdkr2menu
unset public_poolmenu electrumxmenu thunderhubmenu lnddockermenu nginxmenu nostrrelaymenu litdmenu
unset parmacloudmenu parmanostrmenu btcrecovermenu joinmarketmenu greenmenu X11menu

echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Remove Programs$orange                               #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #"
if grep -q "datum-end" $HOME/.parmanode/installed.conf ; then datummenu=1
echo -e "#$cyan                            (datum)$blue            Datum$orange                                  #
#                                                                                      #"
elif grep -q "datum-start" $HOME/.parmanode/installed.conf ; then datummenu=1
echo -e "#$cyan                            (datum)$blue            Datum$orange              $red$blinkon(partial)$blinkoff$orange      #
#                                                                                      #" ; fi
if grep -q "parmacloud-end" $HOME/.parmanode/installed.conf ; then parmacloudmenu=1
echo -e "#$cyan                            (cloud)$blue            ParmaCloud$orange                             #
#                                                                                      #"
elif grep -q "parmacloud-start" $HOME/.parmanode/installed.conf ; then parmacloudmenu=1
echo -e "#$cyan                            (cloud)$blue            ParmaCloud$orange              $red$blinkon(partial)$blinkoff$orange      #
#                                                                                      #" ; fi
if grep -q "website-end" $HOME/.parmanode/installed.conf ; then websitemenu=1
echo -e "#$cyan                            (pw)$blue               WordPress Website (ParmaWeb)           $orange#
#                                                                                      #"
elif grep -q "website-start" $HOME/.parmanode/installed.conf ; then websitemenu=1
echo -e "#$cyan                            (pw)$blue               WordPress Website $red$blinkon(partial)$blinkoff$blue            #
#                                                                                      #" ; fi
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo -e "#$cyan                            (bitcoin)$orange$orange          Bitcoin                                #
#                                                                                      #"
elif grep -q "bitcoin-start" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo -e "#$cyan                            (bitcoin)$orange          Bitcoin $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrummenu=1 
echo -e "#$cyan                            (fulcrum)$orange          Fulcrum Server                         #
#                                                                                      #"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then fulcrummenu=1                                
echo -e "#$cyan                            (fulcrum)$orange          Fulcrum $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "fulcrumdkr-end" $HOME/.parmanode/installed.conf ; then fulcrumdkrmenu=1 
echo -e "#$cyan                            (fulcrumd)$orange         Fulcrum Server (Docker)                #
#                                                                                      #"
elif grep -q "fulcrumdkr-start" $HOME/.parmanode/installed.conf ; then fulcrumdkrmenu=1                                
echo -e "#$cyan                            (fulcrumd)$orange         Fulcrum (Docker)$red$blinkon(partial)$blinkoff$orange              #
#                                                                                      #" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then dockermenu=1 
echo -e "#$cyan                            (docker)$orange           Docker                                 #
#                                                                                      #"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then dockermenu=1                       
echo -e "#$cyan                            (docker)$orange           Docker $red$blinkon(partial)$blinkoff$orange                       #
#                                                                                      #" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpaymenu=1              
echo -e "#$cyan                            (btcp)$orange             BTCPay                                 #
#                                                                                      #"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then btcpaymenu=1
echo -e "#$cyan                            (btcp)$orange             BTCPay $red$blinkon(partial)$blinkoff$orange                       #
#                                                                                      #" ; fi
if which tor >$dn 2>&1 ; then tormenu=1
echo -e "#$cyan                            (tor)$orange              Tor                                    #
#                                                                                      #"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then tormenu=1
echo -e "#$cyan                            (tor)$orange              Tor $red$blinkon(partial)$blinkoff$orange                          #
#                                                                                      #" ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo -e "#$cyan                            (lnd)$orange              LND                                    #
#                                                                                      #"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo -e "#$cyan                            (lnd)$orange              LND $red$blinkon(partial)$blinkoff$orange                          #
#                                                                                      #" ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo -e "#$cyan                            (mem)$orange              Mempool                                #
#                                                                                      #"
elif grep -q "mempool-start" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo -e "#$cyan                            (mem)$orange              Mempool $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo -e "#$cyan                            (s)$orange                Sparrow Wallet                         #
#                                                                                      #"  
elif grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo -e "#$cyan                            (s)$orange                Sparrow $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo -e "#$cyan                            (r)$orange                RTL Wallet                             #
#                                                                                      #" 
elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo -e "#$cyan                            (r)$orange                RTL $red$blinkon(partial)$blinkoff$orange                          #
#                                                                                      #" ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo -e "#$cyan                            (e)$orange                Electrum Wallet                        #
#                                                                                      #"  
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo -e "#$cyan                            (e)$orange                Electrum $red$blinkon(partial)$blinkoff$orange                     #
#                                                                                      #" ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo -e "#$cyan                            (tws)$orange              Tor Web Server                         #
#                                                                                      #"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo -e "#$cyan                            (tws)$orange              Tor Web Server $red$blinkon(partial)$blinkoff$orange               #
#                                                                                      #" ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo -e "#$cyan                            (specter)$orange          Specter Wallet                         #
#                                                                                      #"
elif grep -q "specter-start" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo -e "                                     (specter)          Specter Wallet                 #$cya
#                                                                                      #" ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo -e "#$cyan                            (bre)$orange              BTC RPC Explorer                       #
#                                                                                      #"
elif grep -q "btcrpcexplorer-start" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo -e "#$cyan                            (bre)$orange              BTCrpcEXP $red$blinkon(partial)$blinkoff$orange                    #
#                                                                                      #" ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo -e "#$cyan                            (ers)$orange              electrs                                #
#                                                                                      #"
elif grep -q "electrs-start" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo -e "#$cyan                            (ers)$orange              electrs $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo -e "#$cyan                            (lnb)$orange              LNbits                                 #
#                                                                                      #"
elif grep -q "lnbits-start" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo -e "#$cyan                            (lnb)$orange              LNbits $red$blinkon(partial)$blinkoff$orange                       #
#                                                                                      #" ; fi
if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo -e "#$cyan                            (trz)$orange              Trezor Suite                           #
#                                                                                      #"
elif grep -q "trezor-start" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo -e "#$cyan                            (trz)$orange              Trezor $red$blinkon(partial)$blinkoff$orange                       #
#                                                                                      #" ; fi
if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo -e "#$cyan                            (bb)$orange               BitBox                                 #
#                                                                                      #"
elif grep -q "bitbox-start" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo -e "#$cyan                            (bb)$orange               Bitbox  $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo -e "#$cyan                            (ll)$orange               Ledger                                 #
#                                                                                      #"
elif grep -q "ledger-start" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo -e "#$cyan                            (ll)$orange               Ledger  $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo -e "#$cyan                            (ps)$orange               Parmashell                             #
#                                                                                      #"
elif grep -q "parmashell-start" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo -e "#$cyan                            (ps)$orange               Parmashell  $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo -e "#$cyan                            (bre)$orange              BTC RPC Explorer (Docker)              #
#                                                                                      #"
elif grep -q "bre-start" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo -e "#$cyan                            (bre)$orange              BRE         $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo -e "#$cyan                            (pbx)$orange              ParmaBox                               #
#                                                                                      #"
elif grep -q "parmabox-start" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo -e "#$cyan                            (pbx)$orange              Parmabox    $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo -e "#$cyan                            (any)$orange              AnyDesk                                #
#                                                                                      #"
elif grep -q "anydesk-start" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo -e "#$cyan                            (any)$orange              AnyDesk     $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "pihole-end" $HOME/.parmanode/installed.conf ; then piholemenu=1
echo -e "#$cyan                            (pih)$orange              PiHole                                 #
#                                                                                      #"
elif grep -q "pihole-start" $HOME/.parmanode/installed.conf ; then piholemenu=1
echo -e "#$cyan                            (pih)$orange              PiHole      $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "torrelay-end" $HOME/.parmanode/installed.conf ; then torrelaymenu=1
echo -e "#$cyan                            (trl)$orange              TorRelay                               #
#                                                                                      #"
elif grep -q "torrelay-start" $HOME/.parmanode/installed.conf ; then torrelaymenu=1
echo -e "#$cyan                            (trl)$orange              TorRelay    $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "electrsdkr-end" $HOME/.parmanode/installed.conf ; then electrsdkrmenu=1
echo -e "#$cyan                            (ersd)$orange             Electrs Docker                         #
#                                                                                      #"
elif grep -q "electrsdkr-start" $HOME/.parmanode/installed.conf ; then electrsdkrmenu=1
echo -e "#$cyan                            (ersd)$orange             Electrs Dkr $red$blinkn (partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "electrsdkr2-end" $HOME/.parmanode/installed.conf ; then electrsdkr2menu=1
echo -e "#$cyan                            (ersd)$orange             Electrs Docker                         #
#                                                                                      #"
elif grep -q "electrsdkr2-start" $HOME/.parmanode/installed.conf ; then electrsdkr2menu=1
echo -e "#$cyan                            (ersd)$orange             Electrs Dkr $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "piapps-end" $HOME/.parmanode/installed.conf ; then piappsmenu=1
echo -e "#$cyan                            (piap)$orange             PiApps                                 #
#                                                                                      #"
elif grep -q "piapps-start" $HOME/.parmanode/installed.conf ; then piappsmenu=1
echo -e "#$cyan                            (piap)$orange             PiApps      $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "torb-end" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            (torb)$orange             Tor Browser                            #
#                                                                                      #"
elif grep -q "torb-start" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            (torb)$orange             Tor Browse  $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "qbittorrent-end" $HOME/.parmanode/installed.conf ; then qbittorrentmenu=1
echo -e "#$cyan                            (qbit)$orange             QBittorrent                            #
#                                                                                      #"
elif grep -q "qbittorrent-start" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            (qbit)$orange             QBittorrent$red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "torssh-end" $HOME/.parmanode/installed.conf ; then torsshmenu=1
echo -e "#$cyan                            (tssh)$orange             Tor SSH                                #
#                                                                                      #"
elif grep -q "torssh-start" $HOME/.parmanode/installed.conf ; then torsshmenu=1
echo -e "#$cyan                            (tssh)$orange             Tor SSH $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "electrs2-end" $HOME/.parmanode/installed.conf ; then electrs2menu=1
echo -e "#$cyan                            (ers)$orange              electrs                                #
#                                                                                      #"
elif grep -q "electrs2-start" $HOME/.parmanode/installed.conf ; then electrs2menu=1
echo -e "#$cyan                            (ers)$orange              electrs $red$blinkon(partial)$blinkoff$orange                      #
#                                                                                      #" ; fi
if grep -q "public_pool-end" $HOME/.parmanode/installed.conf ; then public_poolmenu=1
echo -e "#$cyan                            (pool)$orange             Public Pool                            #
#                                                                                      #"
elif grep -q "public_pool-start" $HOME/.parmanode/installed.conf ; then public_poolmenu=1
echo -e "#$cyan                            (pool)$orange             Public Pool $red$blinkon(partial)$blinkoff$orange                  #
#                                                                                      #" ; fi
if grep -q "electrumx-end" $HOME/.parmanode/installed.conf ; then electrumxmenu=1
echo -e "#$cyan                            (ex)$orange               Electrum X                             #
#                                                                                      #"
elif grep -q "electrumx-start" $HOME/.parmanode/installed.conf ; then electrumxmenu=1
echo -e "#$cyan                            (ex)$orange               Electrum X $red$blinkon(partial)$blinkoff$orange                   #
#                                                                                      #" ; fi
if grep -q "thunderhub-end" $HOME/.parmanode/installed.conf ; then thunderhubmenu=1
echo -e "#$cyan                            (th)$orange               Thunderhub                             #
#                                                                                      #"
elif grep -q "thunderhub-start" $HOME/.parmanode/installed.conf ; then thunderhubmenu=1
echo -e "#$cyan                            (th)$orange               Thunderhub $red$blinkon(partial)$blinkoff$orange                   #
#                                                                                      #" ; fi
if grep -q "lnddocker-end" $HOME/.parmanode/installed.conf ; then lnddockermenu=1
echo -e "#$cyan                            (ld)$orange               LND (Docker)                           #
#                                                                                      #"
elif grep -q "lnddocker-start" $HOME/.parmanode/installed.conf ; then lnddockermenu=1
echo -e "#$cyan                            (ld)$orange               LND (Docker)      $red$blinkon(partial)$blinkoff$orange            #
#                                                                                      #" ; fi
if grep -q "nginx-end" $HOME/.parmanode/installed.conf ; then nginxmenu=1
echo -e "#$cyan                            (ng)$orange               Nginx                                  #
#                                                                                      #"
elif grep -q "nginx-start" $HOME/.parmanode/installed.conf ; then nginxmenu=1
echo -e "#$cyan                            (ng)$orange               Nginx             $red$blinkon(partial)$blinkoff$orange            #
#                                                                                      #" ; fi
if grep -q "nostrrelay-end" $HOME/.parmanode/installed.conf ; then nostrrelaymenu=1
echo -e "#$cyan                            (nr)$orange               NOSTR Relay                            #
#                                                                                      #"
elif grep -q "nostrrelay-start" $HOME/.parmanode/installed.conf ; then nostrrelaymenu=1
echo -e "#$cyan                            (nr)$orange               NOSTR Relay       $red$blinkon(partial)$blinkoff$orange            #
#                                                                                      #" ; fi
if grep -q "litd-end" $HOME/.parmanode/installed.conf ; then litdmenu=1
echo -e "#$cyan                            (litd)$orange             LIDT                                   #
#                                                                                      #"
elif grep -q "litd-start" $HOME/.parmanode/installed.conf ; then litdmenu=1
echo -e "#$cyan                            (litd)$orange             LITD              $red$blinkon(partial)$blinkoff$orange            #
#                                                                                      #" ; fi
if grep -q "parmanostr-end" $HOME/.parmanode/installed.conf ; then parmanostrmenu=1
echo -e "#$cyan                            (pnostr)$orange           Parmanostr                             #
#                                                                                      #"
elif grep -q "parmanostr-start" $HOME/.parmanode/installed.conf ; then parmanostrmenu=1
echo -e "#$cyan                            (pnostr)$orange           Parmanostr             $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
if grep -q "btcrecover-end" $HOME/.parmanode/installed.conf ; then btcrecovermenu=1
echo -e "#$cyan                            (btcr)$orange             BTC Recover                            #
#                                                                                      #"
elif grep -q "btcrecover-start" $HOME/.parmanode/installed.conf ; then btcrecovermenu=1
echo -e "#$cyan                            (btcr)$orange             BTC Recover            $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
if grep -q "joinmarket-end" $HOME/.parmanode/installed.conf ; then joinmarketmenu=1
echo -e "#$cyan                            (join)$orange             JoinMarket                             #
#                                                                                      #"
elif grep -q "joinmarket-start" $HOME/.parmanode/installed.conf ; then joinmarketmenu=1
echo -e "#$cyan                            (join)$orange             JoinMarket             $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
if grep -q "green-end" $HOME/.parmanode/installed.conf ; then greenmenu=1
echo -e "#$cyan                            (gr)$orange               Green Wallet                           #
#                                                                                      #"
elif grep -q "green-start" $HOME/.parmanode/installed.conf ; then greenmenu=1
echo -e "#$cyan                            (gr)$orange               Green Wallet           $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
if grep -q "X11-end" $HOME/.parmanode/installed.conf ; then X11menu=1
echo -e "#$cyan                            (x11)$orange              X11                                    #
#                                                                                      #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then X11menu=1
echo -e "#$cyan                            (x11)$orange              X11           $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
if grep -q "phoenix-end" $HOME/.parmanode/installed.conf ; then phoenixmenu=1
echo -e "#$cyan                            (pho)$orange              Phoenix Server                         #
#                                                                                      #"
elif grep -q "phoenix-start" $HOME/.parmanode/installed.conf ; then phoenixmenu=1
echo -e "#$cyan                            (pho)$orange              Phoenix Server         $red$blinkon(partial)$blinkoff$orange       #
#                                                                                      #" ; fi
echo -e "#                                                                                      #
########################################################################################
"
if [[ $1 == "print" ]] ; then return 0 ; fi
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;

parmanode|PARMANODE|Parmanode)
uninstall_parmanode
exit 0
;;

bitcoin|Bitcoin|BITCOIN)
if [[ $bitcoinmenu == 1 ]] ; then
uninstall_bitcoin
menu_main
fi
;;

fulcrum|Fulcrum|FULCRUM)
if [[ $fulcrummenu == 1 ]] ; then
uninstall_fulcrum
menu_main
fi
;;

fulcrumd|Fulcrumd|FULCRUMD)
if [[ $fulcrumdkrmenu == 1 ]] ; then
uninstall_fulcrum
menu_main
fi
;;

docker|Docker|DOCKER)
if [[ $dockermenu == 1 ]] ; then
if [[ $OS == "Mac" ]] ; then uninstall_docker_mac ; fi
if [[ $OS == "Linux" ]] ; then uninstall_docker_linux ; fi
menu_main
fi
;;

btcp|BTCP|Btcp)
if [[ $btcpaymenu == 1 ]] ; then
uninstall_btcpay
menu_main
fi
;;

TOR|Tor|tor)
if [[ $tormenu == 1 ]] ; then
uninstall_tor
menu_main
fi
;;

lnd|LND|Lnd)
if [[ $lndmenu == 1 ]] ; then 
uninstall_lnd 
menu_main 
fi
;;

ld|LD|Ld)
if [[ $lnddockermenu == 1 ]] ; then
uninstall_lnd_docker 
menu_main
fi
;;

mem|MEM|Mem)
if [[ $mempoolmenu == 1 ]] ; then
uninstall_mempool
menu_main
fi
;;

s|S|SPARROW|Sparrow|sparrow)
if [[ $sparrowmenu == 1 ]] ; then
uninstall_sparrow
menu_main	
fi
;;

R|r|RTL|rtl|Rtl)
if [[ $rtlmenu == 1 ]] ; then
uninstall_rtl
menu_main
fi
;;

th)
if [[ $thunderhubmenu == 1 ]] ; then
uninstall_thub
menu_main
fi
;;

e|E|Electrum|electrum|ELECTRUM)
if [[ $electrummenu == 1 ]] ; then
uninstall_electrum
menu_main
fi
;;

tws|TWS|Tws)
if [[ $torservermenu == 1 ]] ; then
no_mac || continue
uninstall_tor_webserver
menu_main
fi
;;

specter|SPECTER|Specter)
if [[ $spectermenu == 1 ]] ; then
uninstall_specter
menu_main
fi
;;

bre|BRE|Bre)
if [[ $btcrpcexplorermenu == 1 ]] ; then
uninstall_btcrpcexplorer
menu_main
fi

if [[ $bredockermenu == 1 ]] ; then
bre_docker_uninstall
menu_main
fi
;;

ers|ERS|Ers|electrs)
if [[ $electrsmenu == 1 ]] ; then
uninstall_electrs
menu_main
fi
	
if [[ $electrs2menu == 1 ]] ; then
uninstall_electrs2
menu_main
fi
;;

lnb|LNB|Lnb)
if [[ $lnbitsmenu == 1 ]] ; then
uninstall_lnbits	
menu_main
fi
;;

trz|TRZ|Trz)
if [[ $trezormenu == 1 ]] ; then
uninstall_trezor
menu_main
fi
;;

bb|BB|Bb)
if [[ $bitboxmenu == 1 ]] ; then
uninstall_bitbox
menu_main
fi
;;

ll|LL|Ll)
if [[ $ledgermenu == 1 ]] ; then
uninstall_ledger
menu_main
fi
;;

ps|PS|Ps)
if [[ $parmashellmenu == 1 ]] ; then
uninstall_parmashell
menu_main
fi
;;

pbx|Pbx)
if [[ $parmaboxmenu == 1 ]] ; then
uninstall_parmabox
menu_main
fi
;;

any|ANY|Any)
if [[ $anydeskmenu == 1 ]] ; then
uninstall_anydesk
menu_main
fi
;;

pih|Pih|PiH)
if [[ $piholemenu == 1 ]] ; then
uninstall_pihole
menu_main
fi
;;

trl|Trl|TRL)
if [[ $torrelaymenu == 1 ]] ; then
uninstall_torrelay
menu_main
fi
;;

ersd|ERSD|Ersd)
if [[ $electrsdkrmenu == 1 ]] ; then
uninstall_electrs_docker
menu_main
fi

if [[ $electrsdkr2menu == 1 ]] ; then
uninstall_electrs_docker2
menu_main
fi
;;

piap|PIAP)
if [[ $piappsmenu == 1 ]] ; then
uninstall_piapps
menu_main
fi
;;

torb|Torb|TORB)
if [[ $torbmenu == 1 ]] ; then
uninstall_torbrowser
menu_main
fi
;;

qbit|Qbit)
if [[ $qbittorrentmenu == 1 ]] ; then
uninstall_qbittorrent
menu_main
fi
;;

tssh)
if [[ $torsshmenu == 1 ]] ; then
uninstall_torssh
menu_main
fi
;;

pool)
if [[ $public_poolmenu == 1 ]] ; then
uninstall_public_pool
menu_main
fi
;;

ex)
if [[ $electrumxmenu == 1 ]] ; then
uninstall_electrumx
menu_main
fi
;;

pw)
if [[ $websitemenu == 1 ]] ; then
uninstall_parmaweb
menu_main
fi
;;

ng)
if [[ $nginxmenu == 1 ]] ; then
uninstall_nginx_warning || return
uninstall_nginx
menu_main
fi
;;

nr)
if [[ $nostrrelaymenu == 1 ]] ; then
uninstall_nostrrelay 
menu_main
fi
;;

litd)
if [[ $litdmenu == 1 ]] ; then
uninstall_litd
menu_main
fi
;;

cloud)
if [[ $parmacloudmenu == 1 ]] ; then
uninstall_parmacloud
menu_main
fi
;;

datum)
if [[ $datummenu == 1 ]] ; then
uninstall_datum
menu_main
fi
;;

pnostr)
if [[ $parmanostrmenu == 1 ]] ; then
uninstall_parmanostr
menu_main
fi
;;

btcr)
if [[ $btcrecovermenu == 1 ]] ; then
uninstall_btcrecover
menu_main
fi
;;

join)
if [[ $joinmarketmenu == 1 ]] ; then
uninstall_joinmarket
menu_main
fi
;;

gr|green)
if [[ $greenmenu == 1 ]] ; then
uninstall_green
menu_main
fi
;;

x11|X11)
if [[ $X11menu == 1 ]] ; then
uninstall_X11
menu_main
fi
;;

pho|PHO)
if [[ $phoenixmenu == 1 ]] ; then
uninstall_phoenix
menu_main
fi
;;

*)
	invalid
	continue
	;;
esac

done

menu_main
}