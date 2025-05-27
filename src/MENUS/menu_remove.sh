function menu_remove {
# another dynamic menu. Each program is listed either as available to be removed, 
# or as a partial (failed) installation, that can be removed. The menu variable is 
# set to toggle the availability of the menu logic below, via if statements.

while true ; do
set_terminal 42
unset bitcoinmenu fulcrummenu dockermenu btcpaymenu lnbitsmenu tormenu lndmenu mempoolmenu 
unset sparrowmenu rtlmenu electrummenu torservermenu btcTORmenu spectermenu btcrpcexplorermenu
unset electrsmenu trezormenu ledgermenu bitboxmenu parmashellmenu bredockermenu parmaboxmenu
unset anydeskmenu piholemenu torrelaymenu electrskdmenu piappsmenu torbmenu 
unset public_poolmenu electrumxmenu thunderhubmenu lnddockermenu nginxmenu nostrrelaymenu litdmenu
unset parmacloudmenu parmanostrmenu btcrecovermenu joinmarketmenu greenmenu X11menu phoenixmenu vaultwardenmenu

echo -e "
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> ${cyan}Remove Programs$orange                               #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #"
if grep -q "parmaview-end" $HOME/.parmanode/installed.conf ; then parmaviewmenu=1
echo -e "#$cyan                            \033[27G pv)$blue               ParmaView$orange                               \033[88G#"
elif grep -q "parmaview-start" $HOME/.parmanode/installed.conf ; then parmaviewmenu=1
echo -e "#$cyan                            \033[27G pv)$blue               ParmaView$orange          $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi

if grep -q "datum-end" $HOME/.parmanode/installed.conf ; then datummenu=1
echo -e "#$cyan                            \033[27G datum)$blue            Datum$orange                                   \033[88G#"
elif grep -q "datum-start" $HOME/.parmanode/installed.conf ; then datummenu=1
echo -e "#$cyan                            \033[27G datum)$blue            Datum$orange              $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "uddns-end" $HOME/.parmanode/installed.conf ; then uddnsmenu=1
echo -e "#$cyan                            \033[27G uddns)$blue            UDDNS$orange                                  \033[88G#"
elif grep -q "uddns-start" $HOME/.parmanode/installed.conf ; then uddnsmenu=1
echo -e "#$cyan                            \033[27G uddns)$blue            UDDNS$orange              $red$blinkon(partial)$blinkoff$orange       \033[88G#" ;fi
if grep -q "parmascale-end" $HOME/.parmanode/installed.conf ; then parmascalemenu=1
echo -e "#$cyan                            \033[27G scale)$blue            ParmaScale$orange                             \033[88G#"
elif grep -q "parmascale-start" $HOME/.parmanode/installed.conf ; then parmascalemenu=1
echo -e "#$cyan                            \033[27G scale)$blue            ParmaScale$orange         $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "parmacloud-end" $HOME/.parmanode/installed.conf ; then parmacloudmenu=1
echo -e "#$cyan                            \033[27G cloud)$blue            ParmaCloud$orange                             \033[88G#"
elif grep -q "parmacloud-start" $HOME/.parmanode/installed.conf ; then parmacloudmenu=1
echo -e "#$cyan                            \033[27G cloud)$blue            ParmaCloud$orange         $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "parmanas-end" $HOME/.parmanode/installed.conf ; then parmanasmenu=1
echo -e "#$cyan                            \033[27G pnas)$blue             ParmaNas$orange                             \033[88G#"
elif grep -q "parmanas-start" $HOME/.parmanode/installed.conf ; then parmanasmenu=1
echo -e "#$cyan                            \033[27G pnas)$blue             ParmaNas$orange         $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "parmasync-end" $HOME/.parmanode/installed.conf ; then parmasyncmenu=1
echo -e "#$cyan                            \033[27G sync)$blue             ParmaSync$orange                             \033[88G#"
elif grep -q "parmasync-start" $HOME/.parmanode/installed.conf ; then parmasyncmenu=1
echo -e "#$cyan                            \033[27G sync)$blue             ParmaSync$orange          $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "parmatwin-end" $HOME/.parmanode/installed.conf ; then parmatwinmenu=1
echo -e "#$cyan                            \033[27G twin)$blue             ParmaTwin$orange                             \033[88G#"
elif grep -q "parmatwin-start" $HOME/.parmanode/installed.conf ; then parmatwinmenu=1
echo -e "#$cyan                            \033[27G twin)$blue             ParmaTwin$orange          $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "website-end" $HOME/.parmanode/installed.conf ; then websitemenu=1
echo -e "#$cyan                            \033[27G pw)$blue               WordPress Website (ParmaWeb)           $orange\033[88G#"
elif grep -q "website-start" $HOME/.parmanode/installed.conf ; then websitemenu=1
echo -e "#$cyan                            \033[27G pw)$blue               WordPress Website         $red$blinkon(partial)$blinkoff$orange       \033[88G#" ; fi
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo -e "#$cyan                            \033[27G bitcoin)$orange          Bitcoin                                \033[88G#"
elif grep -q "bitcoin-start" $HOME/.parmanode/installed.conf ; then bitcoinmenu=1
echo -e "#$cyan                            \033[27G bitcoin)$orange          Bitcoin $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then fulcrummenu=1 
echo -e "#$cyan                            \033[27G fulcrum)$orange          Fulcrum Server                         \033[88G#"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then fulcrummenu=1                                
echo -e "#$cyan                            \033[27G fulcrum)$orange          Fulcrum $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "fulcrumdkr-end" $HOME/.parmanode/installed.conf ; then fulcrumdkrmenu=1 
echo -e "#$cyan                            \033[27G fulcrumd)$orange         Fulcrum Server (Docker)                \033[88G#"
elif grep -q "fulcrumdkr-start" $HOME/.parmanode/installed.conf ; then fulcrumdkrmenu=1                                
echo -e "#$cyan                            \033[27G fulcrumd)$orange         Fulcrum (Docker)$red$blinkon(partial)$blinkoff$orange               \033[88G#" ; fi
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then dockermenu=1 
echo -e "#$cyan                            \033[27G docker)$orange           Docker                                 \033[88G#"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then dockermenu=1                       
echo -e "#$cyan                            \033[27G docker)$orange           Docker $red$blinkon(partial)$blinkoff$orange                        \033[88G#" ; fi
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then btcpaymenu=1              
echo -e "#$cyan                            \033[27G btcp)$orange             BTCPay                                 \033[88G#"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then btcpaymenu=1
echo -e "#$cyan                            \033[27G btcp)$orange             BTCPay $red$blinkon(partial)$blinkoff$orange                        \033[88G#" ; fi
if which tor >$dn 2>&1 ; then tormenu=1
echo -e "#$cyan                            \033[27G tor)$orange              Tor                                    \033[88G#"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then tormenu=1
echo -e "#$cyan                            \033[27G tor)$orange              Tor $red$blinkon(partial)$blinkoff$orange                           \033[88G#" ; fi
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo -e "#$cyan                            \033[27G lnd)$orange              LND                                    \033[88G#"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then lndmenu=1
echo -e "#$cyan                            \033[27G lnd)$orange              LND $red$blinkon(partial)$blinkoff$orange                           \033[88G#" ; fi
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo -e "#$cyan                            \033[27G mem)$orange              Mempool                                \033[88G#"
elif grep -q "mempool-start" $HOME/.parmanode/installed.conf ; then mempoolmenu=1
echo -e "#$cyan                            \033[27G mem)$orange              Mempool $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo -e "#$cyan                            \033[27G s)$orange                Sparrow Wallet                         \033[88G#"
elif grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then sparrowmenu=1
echo -e "#$cyan                            \033[27G s)$orange                Sparrow $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo -e "#$cyan                            \033[27G r)$orange                RTL Wallet                             \033[88G#"
elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then rtlmenu=1
echo -e "#$cyan                            \033[27G r)$orange                RTL $red$blinkon(partial)$blinkoff$orange                           \033[88G#" ; fi
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo -e "#$cyan                            \033[27G e)$orange                Electrum Wallet                        \033[88G#"
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then electrummenu=1
echo -e "#$cyan                            \033[27G e)$orange                Electrum $red$blinkon(partial)$blinkoff$orange                      \033[88G#" ; fi
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo -e "#$cyan                            \033[27G tws)$orange              Tor Web Server                         \033[88G#"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then torservermenu=1
echo -e "#$cyan                            \033[27G tws)$orange              Tor Web Server $red$blinkon(partial)$blinkoff$orange                \033[88G#" ; fi
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo -e "#$cyan                            \033[27G specter)$orange          Specter Wallet                         \033[88G#"
elif grep -q "specter-start" $HOME/.parmanode/installed.conf ; then spectermenu=1
echo -e "                                  \033[27G specter)                 Specter Wallet $red$blinkon(partial)$blinkoff$orange                \033[88G#" ; fi
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo -e "#$cyan                            \033[27G bre)$orange              BTC RPC Explorer                       \033[88G#"
elif grep -q "btcrpcexplorer-start" $HOME/.parmanode/installed.conf ; then btcrpcexplorermenu=1
echo -e "#$cyan                            \033[27G bre)$orange              BTCrpcEXP $red$blinkon(partial)$blinkoff$orange                     \033[88G#" ; fi
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo -e "#$cyan                            \033[27G ers)$orange              electrs                                \033[88G#"
elif grep -q "electrs-start" $HOME/.parmanode/installed.conf ; then electrsmenu=1
echo -e "#$cyan                            \033[27G ers)$orange              electrs $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo -e "#$cyan                            \033[27G lnb)$orange              LNbits                                 \033[88G#"
elif grep -q "lnbits-start" $HOME/.parmanode/installed.conf ; then lnbitsmenu=1
echo -e "#$cyan                            \033[27G lnb)$orange              LNbits $red$blinkon(partial)$blinkoff$orange                        \033[88G#" ; fi
if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo -e "#$cyan                            \033[27G trz)$orange              Trezor Suite                           \033[88G#"
elif grep -q "trezor-start" $HOME/.parmanode/installed.conf ; then trezormenu=1
echo -e "#$cyan                            \033[27G trz)$orange              Trezor $red$blinkon(partial)$blinkoff$orange                        \033[88G#" ; fi
if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo -e "#$cyan                            \033[27G bb)$orange               BitBox                                 \033[88G#"
elif grep -q "bitbox-start" $HOME/.parmanode/installed.conf ; then bitboxmenu=1
echo -e "#$cyan                            \033[27G bb)$orange               Bitbox  $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo -e "#$cyan                            \033[27G ll)$orange               Ledger                                 \033[88G#"
elif grep -q "ledger-start" $HOME/.parmanode/installed.conf ; then ledgermenu=1
echo -e "#$cyan                            \033[27G ll)$orange               Ledger  $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo -e "#$cyan                            \033[27G ps)$orange               Parmashell                             \033[88G#"
elif grep -q "parmashell-start" $HOME/.parmanode/installed.conf ; then parmashellmenu=1
echo -e "#$cyan                            \033[27G ps)$orange               Parmashell  $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo -e "#$cyan                            \033[27G bre)$orange              BTC RPC Explorer (Docker)              \033[88G#"
elif grep -q "bre-start" $HOME/.parmanode/installed.conf ; then bredockermenu=1
echo -e "#$cyan                            \033[27G bre)$orange              BRE         $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo -e "#$cyan                            \033[27G pbx)$orange              ParmaBox                               \033[88G#"
elif grep -q "parmabox-start" $HOME/.parmanode/installed.conf ; then parmaboxmenu=1
echo -e "#$cyan                            \033[27G pbx)$orange              Parmabox    $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo -e "#$cyan                            \033[27G any)$orange              AnyDesk                                \033[88G#"
elif grep -q "anydesk-start" $HOME/.parmanode/installed.conf ; then anydeskmenu=1
echo -e "#$cyan                            \033[27G any)$orange              AnyDesk     $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "pihole-end" $HOME/.parmanode/installed.conf ; then piholemenu=1
echo -e "#$cyan                            \033[27G pih)$orange              PiHole                                 \033[88G#"
elif grep -q "pihole-start" $HOME/.parmanode/installed.conf ; then piholemenu=1
echo -e "#$cyan                            \033[27G pih)$orange              PiHole      $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "torrelay-end" $HOME/.parmanode/installed.conf ; then torrelaymenu=1
echo -e "#$cyan                            \033[27G trl)$orange              TorRelay                               \033[88G#"
elif grep -q "torrelay-start" $HOME/.parmanode/installed.conf ; then torrelaymenu=1
echo -e "#$cyan                            \033[27G trl)$orange              TorRelay    $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "electrsdkr-end" $HOME/.parmanode/installed.conf ; then electrsdkrmenu=1
echo -e "#$cyan                            \033[27G ersd)$orange             Electrs Docker                         \033[88G#"
elif grep -q "electrsdkr-start" $HOME/.parmanode/installed.conf ; then electrsdkrmenu=1
echo -e "#$cyan                            \033[27G ersd)$orange             Electrs Dkr $red$blinkn (partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "piapps-end" $HOME/.parmanode/installed.conf ; then piappsmenu=1
echo -e "#$cyan                            \033[27G piap)$orange             PiApps                                 \033[88G#"
elif grep -q "piapps-start" $HOME/.parmanode/installed.conf ; then piappsmenu=1
echo -e "#$cyan                            \033[27G piap)$orange             PiApps      $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "torb-end" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            \033[27G torb)$orange             Tor Browser                            \033[88G#"
elif grep -q "torb-start" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            \033[27G torb)$orange             Tor Browse  $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "qbittorrent-end" $HOME/.parmanode/installed.conf ; then qbittorrentmenu=1
echo -e "#$cyan                            \033[27G qbit)$orange             QBittorrent                            \033[88G#"
elif grep -q "qbittorrent-start" $HOME/.parmanode/installed.conf ; then torbmenu=1
echo -e "#$cyan                            \033[27G qbit)$orange             QBittorrent$red$blinkon(partial)$blinkoff$orange                    \033[88G#" ; fi
if grep -q "torssh-end" $HOME/.parmanode/installed.conf ; then torsshmenu=1
echo -e "#$cyan                            \033[27G tssh)$orange             Tor SSH                                \033[88G#"
elif grep -q "torssh-start" $HOME/.parmanode/installed.conf ; then torsshmenu=1
echo -e "#$cyan                            \033[27G tssh)$orange             Tor SSH $red$blinkon(partial)$blinkoff$orange                       \033[88G#" ; fi
if grep -q "public_pool-end" $HOME/.parmanode/installed.conf ; then public_poolmenu=1
echo -e "#$cyan                            \033[27G pool)$orange             Public Pool                            \033[88G#"
elif grep -q "public_pool-start" $HOME/.parmanode/installed.conf ; then public_poolmenu=1
echo -e "#$cyan                            \033[27G pool)$orange             Public Pool $red$blinkon(partial)$blinkoff$orange                   \033[88G#" ; fi
if grep -q "electrumx-end" $HOME/.parmanode/installed.conf ; then electrumxmenu=1
echo -e "#$cyan                            \033[27G ex)$orange               Electrum X                             \033[88G#"
elif grep -q "electrumx-start" $HOME/.parmanode/installed.conf ; then electrumxmenu=1
echo -e "#$cyan                            \033[27G ex)$orange               Electrum X $red$blinkon(partial)$blinkoff$orange                    \033[88G#" ; fi
if grep -q "thunderhub-end" $HOME/.parmanode/installed.conf ; then thunderhubmenu=1
echo -e "#$cyan                            \033[27G th)$orange               Thunderhub                             \033[88G#"
elif grep -q "thunderhub-start" $HOME/.parmanode/installed.conf ; then thunderhubmenu=1
echo -e "#$cyan                            \033[27G th)$orange               Thunderhub $red$blinkon(partial)$blinkoff$orange                    \033[88G#" ; fi
if grep -q "lnddocker-end" $HOME/.parmanode/installed.conf ; then lnddockermenu=1
echo -e "#$cyan                            \033[27G ld)$orange               LND (Docker)                           \033[88G#"
elif grep -q "lnddocker-start" $HOME/.parmanode/installed.conf ; then lnddockermenu=1
echo -e "#$cyan                            \033[27G ld)$orange               LND (Docker)      $red$blinkon(partial)$blinkoff$orange             \033[88G#" ; fi
if grep -q "nginx-end" $HOME/.parmanode/installed.conf ; then nginxmenu=1
echo -e "#$cyan                            \033[27G ng)$orange               Nginx                                  \033[88G#"
elif grep -q "nginx-start" $HOME/.parmanode/installed.conf ; then nginxmenu=1
echo -e "#$cyan                            \033[27G ng)$orange               Nginx             $red$blinkon(partial)$blinkoff$orange             \033[88G#" ; fi
if grep -q "nostrrelay-end" $HOME/.parmanode/installed.conf ; then nostrrelaymenu=1
echo -e "#$cyan                            \033[27G nr)$orange               NOSTR Relay                            \033[88G#"
elif grep -q "nostrrelay-start" $HOME/.parmanode/installed.conf ; then nostrrelaymenu=1
echo -e "#$cyan                            \033[27G nr)$orange               NOSTR Relay       $red$blinkon(partial)$blinkoff$orange             \033[88G#" ; fi
if grep -q "litd-end" $HOME/.parmanode/installed.conf ; then litdmenu=1
echo -e "#$cyan                            \033[27G litd)$orange             LIDT                                   \033[88G#"
elif grep -q "litd-start" $HOME/.parmanode/installed.conf ; then litdmenu=1
echo -e "#$cyan                            \033[27G litd)$orange             LITD              $red$blinkon(partial)$blinkoff$orange             \033[88G#" ; fi
if grep -q "parmanostr-end" $HOME/.parmanode/installed.conf ; then parmanostrmenu=1
echo -e "#$cyan                            \033[27G pnostr)$orange           Parmanostr                             \033[88G#"
elif grep -q "parmanostr-start" $HOME/.parmanode/installed.conf ; then parmanostrmenu=1
echo -e "#$cyan                            \033[27G pnostr)$orange           Parmanostr             $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "btcrecover-end" $HOME/.parmanode/installed.conf ; then btcrecovermenu=1
echo -e "#$cyan                            \033[27G btcr)$orange             BTC Recover                            \033[88G#"
elif grep -q "btcrecover-start" $HOME/.parmanode/installed.conf ; then btcrecovermenu=1
echo -e "#$cyan                            \033[27G btcr)$orange             BTC Recover            $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "joinmarket-end" $HOME/.parmanode/installed.conf ; then joinmarketmenu=1
echo -e "#$cyan                            \033[27G join)$orange             JoinMarket                             \033[88G#"
elif grep -q "joinmarket-start" $HOME/.parmanode/installed.conf ; then joinmarketmenu=1
echo -e "#$cyan                            \033[27G join)$orange             JoinMarket             $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "green-end" $HOME/.parmanode/installed.conf ; then greenmenu=1
echo -e "#$cyan                            \033[27G gr)$orange               Green Wallet                           \033[88G#"
elif grep -q "green-start" $HOME/.parmanode/installed.conf ; then greenmenu=1
echo -e "#$cyan                            \033[27G gr)$orange               Green Wallet           $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "X11-end" $HOME/.parmanode/installed.conf ; then X11menu=1
echo -e "#$cyan                            \033[27G x11)$orange              X11                                    \033[88G#"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then X11menu=1
echo -e "#$cyan                            \033[27G x11)$orange              X11                    $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "phoenix-end" $HOME/.parmanode/installed.conf ; then phoenixmenu=1
echo -e "#$cyan                            \033[27G pho)$orange              Phoenix Server                         \033[88G#"
elif grep -q "phoenix-start" $HOME/.parmanode/installed.conf ; then phoenixmenu=1
echo -e "#$cyan                            \033[27G pho)$orange              Phoenix Server         $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "vaultwarden-end" $HOME/.parmanode/installed.conf ; then vaultwardenmenu=1
echo -e "#$cyan                            \033[27G vw)$orange               VaultWarden                            \033[88G#"
elif grep -q "vaultwarden-start" $HOME/.parmanode/installed.conf ; then vaultwardenmenu=1
echo -e "#$cyan                            \033[27G vw)$orange               VaultWarden            $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "nym-end" $HOME/.parmanode/installed.conf ; then nymmenu=1
echo -e "#$cyan                            \033[27G nym)$orange              Nym VPN                                \033[88G#"
elif grep -q "nym-start" $HOME/.parmanode/installed.conf ; then nymmenu=1
echo -e "#$cyan                            \033[27G nym)$orange              Nym VPN                $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
if grep -q "i2p-end" $HOME/.parmanode/installed.conf ; then i2pmenu=1
echo -e "#$cyan                            \033[27G  ii)$orange              I2P                                    \033[88G#"
elif grep -q "i2p-start" $HOME/.parmanode/installed.conf ; then i2pmenu=1
echo -e "#$cyan                            \033[27G  ii)$orange              I2P                    $red$blinkon(partial)$blinkoff$orange        \033[88G#" ; fi
echo -e "#                                                                                      \033[88G#
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

ersd|ERSs|Ersd)
if [[ $electrsdkrmenu == 1 ]] ; then
uninstall_electrs_docker
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

pnas)
if [[ $parmanasmenu == 1 ]] ; then
uninstall_parmanas
menu_main
fi
;;

pv|pview)
if [[ $parmaviewmenu == 1 ]] ; then
uninstall_parmaview
menu_main
fi
;;

datum)
if [[ $datummenu == 1 ]] ; then
uninstall_datum
menu_main
fi
;;

uddns)
if [[ $uddnsmenu == 1 ]] ; then
uninstall_uddns
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

vw)
if [[ $vaultwardenmenu == 1 ]] ; then
uninstall_vaultwarden
menu_main
fi
;;

sync)
if [[ $parmasyncmenu == 1 ]] ; then
uninstall_parmasync
menu_main
fi
;;

twin)
if [[ $parmatwinmenu == 1 ]] ; then
uninstall_parmatwin
menu_main
fi
;;
nym)
if [[ $nymmenu == 1 ]] ; then
uninstall_nym
menu_main
fi
;;
ii|i2p)
if [[ $i2pmenu == 1 ]] ; then
uninstall_i2p
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