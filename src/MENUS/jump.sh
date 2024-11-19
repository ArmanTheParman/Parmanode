function jump {

case $1 in

mbitcoin|mb|bitcoin)
if grep -q "bitcoin-end" $ic ; then
menu_bitcoin
menu_main
fi
;;

melectrs|mers|electrs)
if grep -q "electrs-end" $ic || grep -q "electrsdkr-end" $ic ; then
menu_electrs
menu_main
fi
;;

mfulcrum|mf|fulcrum)
if grep -q "fulcrum-end" $ic ; then
menu_fulcrum
menu_main
fi
;;


melectrumx|mex|electrumx)
if grep -q "electrumx-end" $ic ; then
menu_electrumx
menu_main
fi
;;

mmempool|mmem|mempool)
if grep -q “mempool-end” $ic ; then
menu_mempool
menu_main
fi
;;

mbtcp|btcp|btcpay)
if grep -q "btcpay-end" $ic || grep -q "btccomb-end" $ic ; then
menu_btcpay
menu_main
fi
;;

mlnd|lnd)
if grep -q "lnd-end" $ic ; then
menu_lnd
menu_main
fi
;;

mlt|lt)
if grep -q “litd-end” $ic ; then
menu_lnd
menu_main
fi
;;

melectrum|me|electrum)
if grep -q "electrum-end" $ic ; then
menu_electrum
menu_main
fi
;;

msparrow|ms|sparrow)
if grep -q “sparrow-end” $ic ; then
menu_sparrow
menu_main
fi
;;

mspecter|specter)
if grep -q "specter-end" $ic ; then
menu_specter
menu_main
fi
;;

mbitbox|mbb|bitbox)
if grep -q "bitbox-end" $ic ; then
menu_bitbox
menu_main
fi
;;

mgreen|green)
if grep -q "green-end" $ic ; then
menu_green
menu_main
fi
;;

mledger|ledger)
if grep -q "ledger-end" $ic ; then
menu_ledger
menu_main
fi
;;

mtrezor|trezor)
if grep -q "trezor-end" $ic ; then
menu_trezor
menu_main
fi
;;

add|madd)
menu_add
menu_main
fi
;;

addnode|maddnode)
menu_add_node
menu_main
fi
;;

addwallet|maddwallet)
menu_add_wallet
menu_main
fi
;;

addother|maddother)
menu_add_other
menu_main
fi
;;

addextra|maddextra)
menu_add_extra
menu_main
fi
;;

remove|mremove)
menu_remove
menu_main
fi
;;

use|muse)
menu_use
menu_main
fi
;;

tools|mtools)
menu_tools
menu_main
fi

tools2|mtools2)
menu_tools2
menu_main
fi

;;
mthunderhub|mthub|mth)
if grep -q "thunderhub-end" $ic ; then
menu_thunderhub
menu_main
fi
;;

mrtl|rtl)
if grep -q "rtl-end" $ic ; then
menu_rtl
menu_main
fi
;;

mnostrrelay|mnr|nostrrelay|nr)
if grep -q "nostrrelay-end" $ic ; then
menu_nostrrelay
menu_main
fi
;;

mbre|bre|brcrpcexplorer)
if grep -q "bre-end" $ic ; then
menu_bre
menu_main
fi
;;

mjoinmarket|mjm|jm|joinmarket)
if grep -q "joinmarket-end" $ic ; then
menu_joinmarket
menu_main
fi
;;

mnextcloud|mnxt|mnext|nc|nextcloud)
if grep -q "nextcloud" $ic ; then
menu_nextclourd
menu_main
fi
;;

pbx|mparmabox| mpbx|parmabox)
if grep -q "parmabox-end" $ic ; then
menu_parmabox
menu_main
fi
;;

mqbittorrent|mqbt|qbittorrent)
if grep -q "qbittorrent-end" $ic ; then
menu_qbittorrent
menu_main
fi
;;

pool|mpublicpool|mpool|publicpool)
if grep -q "publicpool-end" $ic ; then
menu_public_pool
menu_main
fi
;;

tor|mtor)
if grep -q "tor-end" $ic ; then
menu_tor
menu_main
fi
;;

torssh|mtorssh)
if grep -q "torssh-end" $ic ; then
menu_torssh
menu_main
fi
;;

esac
}
