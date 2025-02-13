function jump {

case $1 in
q|quit|exit) exit ;;
m|main) back2main ;;

command)
clear
while true ; do
echo -ne "Enter command:\n" ; read -a command
true ; "${command[@]}"
enter_continue "${yellow}Hit$cyan <enter>$yellow to go back, or$green 
a$yellow for another command, or$green
c$yellow to clear first then another command.$orange" "silent"
case $enter_cont in a) continue ;; c) clear ; continue ;; *) break ;; esac
done
invalid_flag=set 
;;

dockerps)
clear ; docker ps ; enter_continue ; invalid_flag=set ;;       

readfunction)
clear
echo -en "########################################################################################

    Enter the name of the function you want to inspect, then hit$cyan <enter>$orange

    Note, you will be reading the entire file where the function is found. $red'q'$orange to exit.
    
    functions are in the pattern, generall, as...
   $green 
        do_something $orange
    
    eg
   $green    
        install_bitcoin$orange

########################################################################################
"
read functionname
file=$(grep -r "function $functionname {" $pn | cut -d : -f 1)
less $file
invalid_flag=set 
;;

motd)
motd
invalid_flag=set
;;

xxxhide)
if ! grep -q "hide_censorship=1" $hm  ; then
    echo "hide_censorship=1" >> $hm
else
nogsedtest
    gsed -i '/hide_censorship/d' $hm >$dn 2>&1
fi

invalid_flag=set
;;

forkids)
parmanode_conf_add "forkids=1"
invalid_flag=set
;;

ff)
parmanode_conf_add "censor_ff=1"
parmanod_conf_remove "forkids=1"
invalid_flag=set
;;

uncensor)
parmanode_conf_remove "forkids"
parmanode_conf_remove "censor_ff"
invalid_flag=set
;;

dm)
menu_drives
invalid_flag=set
;;

ubitcoin|ub|mbitcoin|mb)
if grep -q "bitcoin-end" $ic ; then
menu_bitcoin
invalid_flag=set
else return 1
fi
;;

uelectrs|uers|melectrs|mers)
if grep "electrs" $ic || grep -q end ; then
menu_electrs
invalid_flag=set
else return 1
fi
;;

ufulcrum|uf|mfulcrum|mf|mfd|ufd)
if grep "fulcrum" $ic | grep -q end ; then
menu_fulcrum
invalid_flag=set
else return 1 
fi
;;

uelectrumx|uex|melectrumx|mex)
if grep -q "electrumx-end" $ic ; then
menu_electrumx
invalid_flag=set
else return 1 
fi
;;

umempool|umem|mmempool|mmem)
if grep -q "mempool-end" $ic ; then
menu_mempool
invalid_flag=set
else return 1 
fi
;;

ubtcp|mbtcp)
if grep -q "btcpay-end" $ic || grep -q "btccomb-end" $ic ; then
menu_btcpay
invalid_flag=set
else return 1
fi
;;

ulnd|mlnd|ml|ul)
if grep -q "lnd-end" $ic ; then
menu_lnd
invalid_flag=set
else return 1
fi
;;

ult|mlt)
if grep -q "litd-end" $ic ; then
menu_lnd
invalid_flag=set
else return 1
fi
;;

uelectrum|ue|melectrum|me)
if grep -q "electrum-end" $ic ; then
menu_electrum
invalid_flag=set
else return 1
fi
;;

usparrow|us|msparrow|ms)
if grep -q "sparrow-end" $ic ; then
menu_sparrow
invalid_flag=set
else return 1
fi
;;

uspecter|mspecter)
if grep -q "specter-end" $ic ; then
menu_specter
invalid_flag=set
else return 1
fi
;;

ubitbox|ubb|mbitbox|mbb)
if grep -q "bitbox-end" $ic ; then
menu_bitbox
invalid_flag=set
else return 1
fi
;;

ugreen|ug|mgreen|mg)
if grep -q "green-end" $ic ; then
menu_green
invalid_flag=set
else return 1
fi
;;

uledger|ull|mll|mledger)
if grep -q "ledger-end" $ic ; then
menu_ledger
invalid_flag=set
else return 1
fi
;;

utrezor|mtrezor)
if grep -q "trezor-end" $ic ; then
menu_trezor
invalid_flag=set
else return 1
fi
;;

mmain|main)
menu_main
;;

add|madd)
menu_add
invalid_flag=set
;;

an|addn|addnode|maddnode)
menu_add_node
invalid_flag=set
;;

aw|addw|addwallet|maddwallet)
menu_add_wallets
invalid_flag=set
;;

ao|addo|addother|maddother)
menu_add_other
invalid_flag=set
;;

ae|adde|addextra|maddextra)
menu_add_extra
invalid_flag=set
;;

mremove|remove)
menu_remove
invalid_flag=set
;;

use|muse)
menu_use
invalid_flag=set
;;

tools|mtools)
menu_tools
invalid_flag=set
;;

tools2|mtools2)
menu_tools2
invalid_flag=set
;;

uthunderhub|uthub|uth|mthunderhub|mthub|mth)
if grep -q "thunderhub-end" $ic ; then
menu_thunderhub
invalid_flag=set
else return 1
fi
;;

urtl|mrtl)
if grep -q "rtl-end" $ic ; then
menu_rtl
invalid_flag=set
else return 1
fi
;;

unostrrelay|unr|mnostrrelay|mnr)
if grep -q "nostrrelay-end" $ic ; then
menu_nostrrelay
invalid_flag=set
else return 1
fi
;;

ubre|mbre)
if grep -q "bre-end" $ic ; then
menu_bre
invalid_flag=set
else return 1
fi
;;

upj|uparmajoin|ujoinmarket|ujm|mpj|mparmajoin|mjoinmarket|mjm)
if grep -q "joinmarket-end" $ic ; then
menu_joinmarket
invalid_flag=set
else return 1
fi
;;

unextcloud|unxt|unext|mnextcloud|mnxt|mnext)
if grep -q "nextcloud" $ic ; then
menu_nextclourd
invalid_flag=set
else return 1
fi
;;

uparmabox|upbx|mparmabox|mpbx)
if grep -q "parmabox-end" $ic ; then
menu_parmabox
invalid_flag=set
else return 1
fi
;;

uqbittorrent|uqbt|mqbittorrent|mqbt)
if grep -q "qbittorrent-end" $ic ; then
menu_qbittorrent
invalid_flag=set
else return 1
fi
;;

upublicpool|upool|mpublicpool|mpool)
if grep -q "public_pool-end" $ic ; then
menu_public_pool
invalid_flag=set
else return 1
fi
;;

utor|mtor)
if grep -q "tor-end" $ic ; then
menu_tor
invalid_flag=set
else return 1
fi
;;

utorssh|utssh|mtssh|mtorssh)
if grep -q "torssh-end" $ic ; then
menu_torssh
invalid_flag=set
else return 1
fi
;;

uany|uad|many|mad)
if grep -q "anydesk-end" $ic ; then
menu_anydesk
invalid_flag=set
else return 1
fi
;;

upih|uph|mpih|mph)
if grep -q "pihole-end" $ic ; then
menu_pihole
invalid_flag=set
else return 1
fi
;;

utorrelay|utr|mtr|mtorrelay)
if grep -q "torrely-end" $ic ; then
menu_torrelay
invalid_flag=set
else return 1
fi
;;

utorbrowser|utb|mtb|mtorbrowser)
if grep -q "torb-end" $ic ; then
menu_torbrowser
invalid_flag=set
else return 1
fi
;;

uwebsite|uwps|uws|mwps|mws|mwebsite)
if grep -q "website-end" $ic ; then
menu_parmaweb
invalid_flag=set
else return 1
fi
;;

unginx|ungx|ung|mngx|mng|mnginx)
if grep -q "nginx-end" $ic ; then
menu_nginx
invalid_flag=set
else return 1
fi
;;

ubtcrecover|ubtcr|mbtcr|mbtcrecover)
if grep -q "btcrecover-end" $ic ; then
menu_btcrecover
invalid_flag=set
else return 1
fi
;;

ux11)
if grep -q "X11-end" $ic ; then
menu_X11
invalid_flag=set
else return 1
fi
;;

upho)
if grep -q "phoenix-end" $ic ; then
menu_phoenix
invalid_flag=set
else return 1
fi
;;

ujoin|mjoin)
if grep -q "joinmarket-end" $ic ; then
menu_joinmarket
invalid_flag=set
else return 1
fi
;;

code|Code|CODE)
less $pn/src/MENUS/jump.sh
invalid_flag=set
return 1 #value 1 is necessary
;;

bash)
tmux new -s pnbash "bash=1 rp"
;;

upm)
if [[ -e $pp/parminer ]] ; then
menu_parminer
invalid_flag=set
else
return 1
fi
;;

esac
}

function jump_qpm {
case $1 in
q|Q) exit ;;
p|P) return 1 ;;
m|returnM) back2main ;;
esac
}
