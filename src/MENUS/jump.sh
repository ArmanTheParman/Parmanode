function jump {

case $1 in

mbitcoin|mb)
if grep -q "bitcoin-end" $ic ; then
menu_bitcoin
menu_main
else return 1
fi
;;

melectrs|mers)
if grep -q "electrs-end" $ic || grep -q "electrsdkr-end" $ic ; then
menu_electrs
menu_main
else return 1
fi
;;

mfulcrum|mf)
if grep -q "fulcrum-end" $ic ; then
menu_fulcrum
menu_main
else return 1 
fi
;;

melectrumx|mex)
if grep -q "electrumx-end" $ic ; then
menu_electrumx
menu_main
else return 1 
fi
;;

mmempool|mmem)
if grep -q “mempool-end” $ic ; then
menu_mempool
menu_main
else return 1 
fi
;;

mbtcp|btcp)
if grep -q "btcpay-end" $ic || grep -q "btccomb-end" $ic ; then
menu_btcpay
menu_main
else return 1
fi
;;

mlnd)
if grep -q "lnd-end" $ic ; then
menu_lnd
menu_main
else return 1
fi
;;

mlt)
if grep -q “litd-end” $ic ; then
menu_lnd
menu_main
else return 1
fi
;;

melectrum|me)
if grep -q "electrum-end" $ic ; then
menu_electrum
menu_main
else return 1
fi
;;

msparrow|ms)
if grep -q “sparrow-end” $ic ; then
menu_sparrow
menu_main
else return 1
fi
;;

mspecter)
if grep -q "specter-end" $ic ; then
menu_specter
menu_main
else return 1
fi
;;

mbitbox|mbb)
if grep -q "bitbox-end" $ic ; then
menu_bitbox
menu_main
else return 1
fi
;;

mgreen|mg)
if grep -q "green-end" $ic ; then
menu_green
menu_main
else return 1
fi
;;

mll|mledger)
if grep -q "ledger-end" $ic ; then
menu_ledger
menu_main
else return 1
fi
;;

mtrezor)
if grep -q "trezor-end" $ic ; then
menu_trezor
menu_main
else return 1
fi
;;

mmain|main)
menu_main
;;

add|madd)
menu_add
menu_main
;;

addn|addnode|maddnode)
menu_add_node
menu_main
;;

addw|addwallet|maddwallet)
menu_add_wallet
menu_main
;;

addo|addother|maddother)
menu_add_other
menu_main
;;

adde|addextra|maddextra)
menu_add_extra
menu_main
;;

remove|mremove)
menu_remove
menu_main
;;

use|muse)
menu_use
menu_main
;;

tools|mtools)
menu_tools
menu_main
;;

tools2|mtools2)
menu_tools2
menu_main
;;

mthunderhub|mthub|mth)
if grep -q "thunderhub-end" $ic ; then
menu_thunderhub
menu_main
else return 1
fi
;;

mrtl)
if grep -q "rtl-end" $ic ; then
menu_rtl
menu_main
else return 1
fi
;;

mnostrrelay|mnr)
if grep -q "nostrrelay-end" $ic ; then
menu_nostrrelay
menu_main
else return 1
fi
;;

mbre)
if grep -q "bre-end" $ic ; then
menu_bre
menu_main
else return 1
fi
;;

mpj|mparmajoin|mjoinmarket|mjm)
if grep -q "joinmarket-end" $ic ; then
menu_joinmarket
menu_main
else return 1
fi
;;

mnextcloud|mnxt|mnext)
if grep -q "nextcloud" $ic ; then
menu_nextclourd
menu_main
else return 1
fi
;;

mparmabox|mpbx)
if grep -q "parmabox-end" $ic ; then
menu_parmabox
menu_main
else return 1
fi
;;

mqbittorrent|mqbt)
if grep -q "qbittorrent-end" $ic ; then
menu_qbittorrent
menu_main
else return 1
fi
;;

mpublicpool|mpool)
if grep -q "publicpool-end" $ic ; then
menu_public_pool
menu_main
else return 1
fi
;;

mtor)
if grep -q "tor-end" $ic ; then
menu_tor
menu_main
else return 1
fi
;;

mtssh|mtorssh)
if grep -q "torssh-end" $ic ; then
menu_torssh
menu_main
else return 1
fi
;;

mtorssh)
if grep -q "torssh-end" $ic ; then
menu_torssh
menu_main
else return 1
fi
;;

many|mad)
if grep -q "anydesk-end" $ic ; then
menu_anydesk
menu_main
else return 1
fi
;;

mpih|mph)
if grep -q "pihole-end" $ic ; then
menu_pihole
menu_main
else return 1
fi
;;

mtr|mtorrelay)
if grep -q "torrely-end" $ic ; then
menu_torrelay
menu_main
else return 1
fi
;;

mtb|mtorbrowser)
if grep -q "torbrowser-end" $ic ; then
menu_torbrowser
menu_main
else return 1
fi
;;

mwps|mws|mwebsite)
if grep -q "website-end" $ic ; then
menu_website
menu_main
else return 1
fi
;;

mngx|mng|mnginx)
if grep -q "nginx-end" $ic ; then
menu_nginx
menu_main
else return 1
fi
;;

mbtcr|mbtcrecover)
if grep -q "btcrecover-end" $ic ; then
menu_btcrecover
menu_main
else return 1
fi
;;

code|Code|CODE)
less $pn/src/MENUS/jump.sh
invalid_flag=set
return 1 #value 1 is necessary
;;

esac
}
