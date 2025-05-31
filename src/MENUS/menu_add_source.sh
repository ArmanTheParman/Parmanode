function menu_add_source {

#BITCOIN
unset bitcoin_i bitcoin_p bitcoin_n
if grep -q "bitcoin-end" $HOME/.parmanode/installed.conf ; then 
   #installed
bitcoin_i="#                                      Bitcoin Core/Knots                              #"

elif grep -q "bitcoin-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
bitcoin_p="#                                      Bitcoin Core/Knots                              #"
else 
   #not installed
bitcoin_n="#$cyan                             b)$orange           Bitcoin Core/Knots                          #"
fi

#DOCKER
unset docker_i docker_p docker_n
if grep -q "docker-end" $HOME/.parmanode/installed.conf ; then 
   #installed
docker_i="#                                      Docker                                          #"
elif grep -q "docker-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
docker_p="#                                      Docker                                          #"
else
   #not installed
docker_n="#$cyan                             d)$orange           Docker                                      #"
fi

#FULCRUM
unset fulcrum_i fulcrum_p fulcrum_n
if  grep -q "fulcrum-end" $HOME/.parmanode/installed.conf ; then 
   #installed
fulcrum_i="#                                      Fulcrum                                         #"
elif grep -q "fulcrum-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
fulcrum_p="#                                      Fulcrum                                         #"
else
   #not installed
fulcrum_n="#$cyan                             f)$orange           Fulcrum                                     #" 
    if grep -q "fulcrumdkr-" $ic ; then unset fulcrum_n ; fi
fi
#FULCRUMDKR
unset fulcrumdkr_i fulcrumdkr_p fulcrumdkr_n
if  grep -q "fulcrumdkr-end" $HOME/.parmanode/installed.conf ; then 
   #installed
fulcrumdkr_i="#                                      Fulcrum (Docker)                                #"
elif grep -q "fulcrumdkr-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
fulcrumdkr_p="#                                      Fulcrum (Docker)                                #"
else
   #not installed
fulcrumdkr_n="#$cyan                             fd)$orange          Fulcrum (in Docker)                         #"
    if grep -q "fulcrum-" $ic ; then unset fulcrumdkr_n ; fi
fi

#BTCPAY
unset btcpay_i btcpay_p btcpay_n
if grep -q "btcpay-end" $HOME/.parmanode/installed.conf ; then 
   #installed
btcpay_i="#                                      BTCPay Server                                   #"
elif grep -q "btcpay-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcpay_p="#                                      BTCPay Server                                   #"
else
   #not installed
btcpay_n="#$cyan                             btcp)$orange        BTCPay Server                               #"
fi

#Sparrow
unset sparrow_i sparrow_p sparrow_n
if grep -q "sparrow-end" $HOME/.parmanode/installed.conf ; then  
   #installed
sparrow_i="#                                      Sparrow Wallet                                  #"
elif grep -q "sparrow-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
sparrow_p="#                                      Sparrow Wallet                                  #"
else
   #not installed
sparrow_n="#$cyan                             s)$orange           Sparrow Wallet                              #"
fi

#Electrs
unset electrs_i electrs_p electrs_n
if grep -q "electrs-end" $HOME/.parmanode/installed.conf ; then 
   #installed
electrs_i="#                                      electrs                                         #"
elif grep -q "electrs-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
electrs_p="#                                      electrs                                         #"
else
   #not installed
electrs_n="#$cyan                             ers)$orange         electrs                                     #"
    if grep -q "electrsdkr-" $ic ; then unset electrs_n ; fi
fi


#LND
unset lnd_i lnd_p lnd_n
if grep -q "lnd-end" $HOME/.parmanode/installed.conf ; then 
  #installed
lnd_i="#                                      LND                                             #"
elif grep -q "lnd-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
lnd_p="#                                      LND                                             #"
else
   #not installed
lnd_n="#$cyan                             lnd) $orange        LND                                         #"
fi

#RTL
unset rtl_i rtl_p rtl_n
if grep -q "rtl-end" $HOME/.parmanode/installed.conf ; then 
  #installed
rtl_i="#                                      RTL Wallet                                      #"
elif grep -q "rtl-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
rtl_p="#                                      RTL Wallet                                      #"
else
   #not installed
rtl_n="#$cyan                             r) $orange          RTL Wallet                                  #"
fi

#Electrum
unset electrum_p electrum_n electrum_i
if grep -q "electrum-end" $HOME/.parmanode/installed.conf ; then 
  #installed
electrum_i="#                                      Electrum                                        #"
elif grep -q "electrum-start" $HOME/.parmanode/installed.conf ; then 
  #partially installed
electrum_p="#                                      Electrum                                        #"
else
 #not installed 
electrum_n="#$cyan                             e) $orange          Electrum                                    #"
fi


#Tor
unset tor_i tor_p tor_n
if grep -q "tor-end" $HOME/.parmanode/installed.conf ; then 
  #installed
tor_i="#                                      Tor                                             #"
elif grep -q "tor-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
tor_p="#                                      Tor                                             #"
else
   #not installed
tor_n="#$cyan                             t) $orange          Tor                                         #"
fi

#Specter
unset specter_i specter_p specter_n
if grep -q "specter-end" $HOME/.parmanode/installed.conf ; then 
  #installed
specter_i="#                                      Specter Wallet                                  #"
elif grep -q "specter-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
specter_p="#                                      Specter Wallet                                  #"
else
   #not installed
specter_n="#$cyan                             specter) $orange    Specter Wallet                              #"
fi

#Tor Server
unset torserver_i torserver_p torserver_n
if grep -q "tor-server-end" $HOME/.parmanode/installed.conf ; then 
  #installed
torserver_i="#                                      Tor Web Server                                  #"
elif grep -q "tor-server-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
torserver_p="#                                      Tor Web Server                                  #"
else
   #not installed
torserver_n="#$cyan                             tws)      $orange   Tor Web Server (Darknet Server)             #"
fi

#BTC RPC Explorer (not Docker)
unset btcrpcexplorer_i btcrpcexplorer_p btcrpcexplorer_n
if grep -q "btcrpcexplorer-end" $HOME/.parmanode/installed.conf ; then 
  #installed
btcrpcexplorer_i="#                                      BTC RPC Explorer                                #"
elif grep -q "btcrpcexplore-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcrpcexplorer_p="#                                      BTC RPC Explorer                                #"
else
   #not installed
btcrpcexplorer_n="#$cyan                             bre)       $orange  BTC RPC Explorer                            #"
fi

#BTC RPC Explorer (Docker)
unset bre_i bre_p bre_n 
if grep -q "bre-end" $HOME/.parmanode/installed.conf ; then 
  #installed
bre_i="#                                      BTC RPC Explorer (Docker)                       #"
elif grep -q "bre-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
bre_p="#                                      BTC RPC Explorer (Docker)                       #"
else
   #not installed
bre_n="#$cyan                             bre)        $orange BTC RPC Explorer (Docker)                   #"
fi

#LNbits
unset lnbits_i lnbits_p lnbits_n
if grep -q "lnbits-end" $HOME/.parmanode/installed.conf ; then 
  #installed
lnbits_i="#                                      LNbits                                          #"
elif grep -q "lnbits-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
lnbits_p="#                                      LNbits                                          #"
else
   #not installed
lnbits_n="#$cyan                             lnb)     $orange    LNbits                                      #"
fi

#trezor
unset trezor_i trezor_p trezor_n

if grep -q "trezor-end" $HOME/.parmanode/installed.conf ; then 
  #installed
trezor_i="#                                      Trezor Suite                                    #"
elif grep -q "trezor-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
trezor_p="#                                      Trezor Suite                                    #"
else
   #not installed
trezor_n="#$cyan                             trz)     $orange    Trezor Suite                                #"
fi

#Bitbox
unset bitbox_i bitbox_p bitbox_n

if grep -q "bitbox-end" $HOME/.parmanode/installed.conf ; then 
  #installed
bitbox_i="#                                      BitBox                                          #"
elif grep -q "bitbox-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
bitbox_p="#                                      BitBox                                          #"
else
   #not installed
bitbox_n="#$cyan                             bb)       $orange   Bitbox                                      #"
fi

#Ledger
unset ledger_i ledger_p ledger_n

if grep -q "ledger-end" $HOME/.parmanode/installed.conf ; then 
  #installed
ledger_i="#                                      Ledger                                          #"
elif grep -q "ledger-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
ledger_p="#                                      Ledger                                          #"
else
   #not installed
ledger_n="#$cyan                             ll)       $orange   Ledger                                      #"
fi

#Parmashell
unset parmashell_i parmashell_p parmashell_n

if grep -q "parmashell-end" $HOME/.parmanode/installed.conf ; then 
  #installed
parmashell_i="#                                      ParmaShell                                      #"
elif grep -q "parmashell-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
parmashell_p="#                                      ParmaShell                                      #"
else
   #not installed
parmashell_n="#$cyan                             ps)       $orange   ParmaShell                                  #"
fi

#NodeJS
unset nodejs_i nodejs_p_ nodejs_n 

if grep -q "nodejs-end" $HOME/.parmanode/installed.conf ; then 
  #installed
nodejs_i="#                                      NodeJS                                       #"
elif grep -q "nodejs-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
nodejs_p="#                                      NodeJS                                       #"
else
   #not installed
nodejs_n="#$cyan                             njs)        $orange  NodeJS                                  #"
fi

#Parmabox
unset parmabox_n parmabox_i parmabox_p

if grep -q "parmabox-end" $HOME/.parmanode/installed.conf ; then 
  #installed
parmabox_i="#                                      ParmaBox                                        #"
elif grep -q "parmabox-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
parmabox_p="#                                      ParmaBox                                        #"
else
   #not installed
parmabox_n="#$cyan                             pbx)        $orange Parmabox                                    #"
fi

#AnyDesk
unset anydesk_i anydesk_p anydesk_n 

if grep -q "anydesk-end" $HOME/.parmanode/installed.conf ; then 
  #installed
anydesk_i="#                                      AnyDesk                                         #"
elif grep -q "anydesk-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
anydesk_p="#                                      AnyDesk                                         #"
else
   #not installed
anydesk_n="#$cyan                             any)        $orange AnyDesk                                     #"
fi

#PiHole
unset pihole_i pihole_p pihole_n 

if grep -q "pihole-end" $HOME/.parmanode/installed.conf ; then 
  #installed
pihole_i="#                                      PiHole                                          #"
elif grep -q "pihole-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
pihole_p="#                                      PiHole                                          #"
else
   #not installed
pihole_n="#$cyan                             pih)        $orange PiHole                                      #"
fi

#Torrelay
unset torrelay_i torrelay_p torrelay_n 

if grep -q "torrelay-end" $HOME/.parmanode/installed.conf ; then 
  #installed
torrelay_i="#                                      TorRelay                                        #"
elif grep -q "torrelay-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
torrelay_p="#                                      TorRelay                                        #"
else
   #not installed
torrelay_n="#$cyan                             trl)     $orange    TorRelay                                    #"
fi

#Electrsdkr
unset electrsdkr_i electrsdkr_p electrsdkr_n
if grep -q "electrsdkr-end" $HOME/.parmanode/installed.conf ; then 
   #installed
electrsdkr_i="#                                      electrs (Docker)                                #"
elif grep -q "electrsdkr-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
electrsdkr_p="#                                      electrs (Docker)                                #"
else
   #not installed
electrsdkr_n="#$cyan                             ersd)      $orange  electrs (Docker)                            #"
    if grep -q "electrs-" $ic ; then unset electrsdkr_n ; fi
fi

#piapps
if [[ $computer_type == Pi ]] ; then
unset piapps_i piapps_p piapps_n 
if grep -q "piapps-end" $HOME/.parmanode/installed.conf ; then 
   #installed
piapps_i="#                                      PiApps                                          #"
elif grep -q "piapps-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
piapps_p="#                                      PiApps                                          #"
else
   #not installed
piapps_n="#$cyan                             piap)      $orange  PiApps                                      #"
fi
fi #end computer type = Pi

#Tor Browswer
if [[ $computer_type == LinuxPC || $OS == Mac ]] ; then
unset torb_n torb_i torb_p 
if grep -q "torb-end" $HOME/.parmanode/installed.conf ; then 
   #installed
torb_i="#                                      Tor Browser                                     #"
elif grep -q "torb-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
torb_p="#                                      Tor Browser                                     #"
else
   #not installed
torb_n="#$cyan                             torb)   $orange     Tor Browser                                 #"
fi
fi #end computer type/OS

#QBittorrent
if [[ $computer_type == LinuxPC || $OS == Mac ]] ; then
unset qbittorrent_i qbittorrent_p qbittorrent_n
if grep -q "qbittorrent-end" $HOME/.parmanode/installed.conf ; then 
   #installed
qbittorrent_i="#                                      QBittorrent                                     #"
elif grep -q "qbittorrent-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
qbittorrent_p="#                                      QBittorrent                                     #"
else
   #not installed
qbittorrent_n="#$cyan                             qbit)      $orange  QBittorrent                                 #"
fi
fi #end computer type/OS

#Mempool
unset mempool_i mempool_p mempool_n
if grep -q "mempool-end" $HOME/.parmanode/installed.conf ; then 
   #installed
mempool_i="#                                      Mempool (Docker)                                #"
elif grep -q "mempool-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
mempool_p="#                                      Mempool (Docker)                                #"
else
   #not installed
mempool_n="#$cyan                             mem)       $orange  Mempool (Docker)                            #"
fi

#torssh
unset torssh_i torssh_p torssh_n 
if grep -q "torssh-end" $HOME/.parmanode/installed.conf ; then 
   #installed
torssh_i="#                                      Tor SSH Server                                  #"
elif grep -q "torssh-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
torssh_p="#                                      Tor SSH Server                                  #"
else
   #not installed
torssh_n="#$cyan                             tssh)    $orange    Tor SSH Server                              #"
fi

#public_pool
unset public_pool_i public_pool_p public_pool_n
if grep -q "public_pool-end" $HOME/.parmanode/installed.conf ; then 
   #installed
public_pool_i="#                                      Public Pool                                     #"
elif grep -q "public_pool-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
public_pool_p="#                                      Public Pool                                     #"
else
   #not installed
public_pool_n="#$cyan                             pool)      $orange  Public Pool                                 #"
fi

#Electrumx
unset electrumx_i electrux_p electrumx_n
if grep -q "electrumx-end" $HOME/.parmanode/installed.conf ; then 
   #installed
electrumx_i="#                                      Electrum X                                      #"
elif grep -q "electrumx-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
electrumx_p="#                                      Electrum X                                      #"
else
   #not installed
electrumx_n="#$cyan                             ex)        $orange  Electrum X                                  #"
fi

#Thunderhub
unset thunderhub_i thunderhub_p thunderhub_n
if grep -q "thunderhub-end" $HOME/.parmanode/installed.conf ; then 
   #installed
thunderhub_i="#                                      Thunderhub                                      #"
elif grep -q "thunderhub-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
thunderhub_p="#                                      Thunderhub                                      #"
else
   #not installed
thunderhub_n="#$cyan                             th)        $orange  Thunderhub                                  #"
fi

#website
unset website_i website_p website_n
if grep -q "website-end" $HOME/.parmanode/installed.conf ; then 
   #installed
website_i="#                                      WordPress Website (ParmaWeb)                    #"
elif grep -q "website-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
website_p="#                                      WordPress Website (ParmaWeb)                    #"
else
   #not installed
website_n="#$cyan                             pw)        $orange  Wordpress Website (ParmaWeb)                #"
fi

#lnddocker
unset lnddocker_i lnddocker_p lnddocker_n
if grep -q "lnddocker-end" $HOME/.parmanode/installed.conf ; then
   #installed
lnddocker_i="#                                      LND (Docker)                                    #"
elif grep -q "lnddocker-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
lnddocker_p="#                                      Lnd (Docker)                                    #"
else
   #not installed
lnddocker_n="#$cyan                             ld)        $orange  Lnd (Docker) - Mac or Linux                 #"
fi

#nginx
unset nginx_i nginx_p nginx_n
if grep -q "nginx-end" $HOME/.parmanode/installed.conf ; then
   #installed
nginx_i="#                                      Nginx                                           #"
elif grep -q "nginx-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
nginx_p="#                                      Nginx                                           #"
else
   #not installed
nginx_n="#$cyan                             ng)        $orange  Nginx                                       #"
fi

#nostrrelay
unset nostrrelay_i nostrrelay_p nostrrelay_n
if grep -q "nostrrelay-end" $HOME/.parmanode/installed.conf ; then
   #installed
nostrrelay_i="#                                      Nostr Relay                                     #"
elif grep -q "nostrrelay-start" $HOME/.parmanode/installed.conf ; then
   #partially installed
nostrrelay_p="#                                      Nostr Relay                                     #"
else
   #not installed
nostrrelay_n="#$cyan                             nr)        $orange  Nostr Relay                                 #"
fi

#litd
unset litd_i litd_p litd_n
if grep -q "litd-end" $HOME/.parmanode/installed.conf ; then 
  #installed
litd_i="#                                      LITD                                            #"
elif grep -q "litd-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
litd_p="#                                      LITD                                            #"
else
   #not installed
litd_n="#$cyan                             litd)      $orange  LITD (Lightning terminal, pool, loop)       #"
fi

#nextcloud
unset nextcloud_i nextcloud_p next_cloud_n
if grep -q "nextcloud-end" $HOME/.parmanode/installed.conf ; then 
  #installed
nextcloud_i="#$blue                                      ParmaCloud                                      $orange#"
elif grep -q "nextcloud-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
nextcloud_p="#$blue                                      ParmaCloud                                      $orange#"
else
   #not installed
nextcloud_n="#$cyan                             cloud)      $blue ParmaCloud                                  $orange#"
fi

#parmanostr
unset parmanostr_i parmanostr_p parmanostr_n
if grep -q "parmanostr-end" $HOME/.parmanode/installed.conf ; then 
  #installed
parmanostr_i="#                                      Parmanostr                                      #"
elif grep -q "parmanostr-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
parmanostr_p="#                                      Parmanostr                                      #"
else
   #not installed
parmanostr_n="#$cyan                             pnostr)    $orange  Parmanostr                                  #"
fi


#BTCRecover
unset btcrecover_i btcrecover_p btcrecover_n
if grep -q "btcrecover-end" $HOME/.parmanode/installed.conf ; then 
  #installed
btcrecover_i="#                                      BTC Recover                                     #"
elif grep -q "btcrecover-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
btcrecover_p="#                                      BTC Recover                                     #"
else
   #not installed
btcrecover_n="#$cyan                             btcr)    $orange    BTC recover                                 #"
fi

#joinmarket
unset joinmarket_i joinmarket_p joinmarket_n
if grep -q "joinmarket-end" $HOME/.parmanode/installed.conf ; then 
  #installed
joinmarket_i="#                                      ParmaJoin                                       #"
elif grep -q "joinmarket-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
joinmarket_p="#                                      ParmaJoin                                       #"
else
   #not installed
joinmarket_n="#$cyan                             join)    $orange    ParmaJoin (JoinMarket) - Linux only         #"
fi

#green
unset green_i green_p green_n
if grep -q "green-end" $HOME/.parmanode/installed.conf ; then 
  #installed
green_i="#                                      Green Wallet                                    #"
elif grep -q "green-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
green_p="#                                      Green Wallet                                    #"
else
   #not installed
green_n="#$cyan                             gr)    $orange      Green Wallet                                #"
fi

#x11
unset X11_i X11_p X11_n
if grep -q "X11-end" $HOME/.parmanode/installed.conf ; then 
  #installed
X11_i="#                                      X11                                             #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
X11_p="#                                      X11                                             #"
else
   #not installed
X11_n="#$cyan                             X11)   $orange      X11                                         #"
fi

#Phoenix
unset phoenix_i phoenix_p phoenix_n
if grep -q "phoenix-end" $HOME/.parmanode/installed.conf ; then 
  #installed
phoenix_i="#                                      Phoenix Server                                  #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
phoenix_p="#                                      Phoenix Server                                  #"
else
   #not installed
phoenix_n="#$cyan                             pho)   $orange      Phoenix Server                              #"
fi

#Vaultwarden
unset vaultwarden_i vaultwarden_p vaultwarden_n
if grep -q "vaultwarden-end" $HOME/.parmanode/installed.conf ; then 
  #installed
vaultwarden_i="#                                      VaultWarden                                     #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
vaultwarden_p="#                                      VaultWarden                                     #"
else
   #not installed
vaultwarden_n="#$cyan                             vw)    $orange      VaultWarden                                 #"
fi

#ParmaSync
unset parmasync_i parmasync_p parmasync_n
if grep -q "parmasync-end" $HOME/.parmanode/installed.conf ; then 
  #installed
parmasync_i="#                                      ParmaSync                                       #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
parmasync_p="#                                      ParmaSync                                       #"
else
   #not installed
parmasync_n="#$cyan                             sync)    $orange    ParmaSync                                   #"
fi

#ParmaTwin
unset parmatwin_i parmatwin_p parmatwin_n
if grep -q "parmatwin-end" $HOME/.parmanode/installed.conf ; then 
  #installed
parmatwin_i="#                                      ParmaTwin                                       #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
parmatwin_p="#                                      ParmaTwin                                       #"
else
   #not installed
parmatwin_n="#$cyan                             twin)    $orange    ParmaTwin                                   #"
fi

#nym
unset num_i nym_p nym_n
if grep -q "nym-end" $HOME/.parmanode/installed.conf ; then 
  #installed
nym_i="#                                      Nym VPN                                         #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
nym_p="#                                      Nym VPN                                         #"
else
   #not installed
nym_n="#$cyan                             nym)    $orange     Nym VPN                                     #"
fi

#i2p
unset i2p_i i2p_p i2p_n
if grep -q "i2p-end" $HOME/.parmanode/installed.conf ; then 
  #installed
i2p_i="#                                      I2P                                             #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
i2p_p="#                                      I2P                                             #"
else
   #not installed
i2p_n="#$cyan                             ii)    $orange      I2P                                         #"
fi

#vnc
unset vnc_i vnc_p vnc_n 
if grep -q "vnc-end" $HOME/.parmanode/installed.conf ; then 
  #installed
vnc_i="#                                      VNC                                             #"
elif grep -q "X11-start" $HOME/.parmanode/installed.conf ; then 
   #partially installed
vnc_p="#                                      VNC                                             #"
else
   #not installed
vnc_n="#$cyan                             vnc)   $orange       VNC                                         #"
fi

}
