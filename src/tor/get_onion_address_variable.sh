function get_onion_address_variable {
if [[ $OS == Mac ]] ; then
varlibtor="/usr/local/var/lib/tor"
else
varlibtor="/var/lib/tor"
fi

if [[ $1 == "bitcoin" ]] ; then
export ONION_ADDR="$(sudo cat $varlibtor/bitcoin-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "fulcrum" ]] ; then
export ONION_ADDR_FULCRUM="$(sudo cat $varlibtor/fulcrum-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "bre" ]] ; then
export ONION_ADDR_BRE="$(sudo cat $varlibtor/bre-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "electrs" ]] ; then
export ONION_ADDR_ELECTRS="$(sudo cat $varlibtor/electrs-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "rtl" ]] ; then
export ONION_ADDR_RTL="$(sudo cat $varlibtor/rtl-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "mempool" ]] ; then
export ONION_ADDR_MEM="$(sudo cat $varlibtor/mempool-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "ssh" ]] ; then
export ONION_ADDR_SSH="$(sudo cat $varlibtor/ssh-service/hostname 2>/dev/null)" 
debug "$ONION_ADDR_SSH, hit <enter>"
return 0
fi

if [[ $1 == "public_pool" ]] ; then
export ONION_ADDR_PP="$(sudo cat $varlibtor/public_pool-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "electrumx" ]] ; then
export ONION_ADDR_ELECTRUMX="$(sudo cat $varlibtor/electrumx-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "website" ]] ; then
export ONION_ADDR_WEBSITE="$(sudo cat $varlibtor/website-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "thunderhub" ]] ; then
export ONION_ADDR_THUB="$(sudo cat $varlibtor/thunderhub-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "nostr" ]] ; then
export ONION_ADDR_NOSTR="$(sudo cat $varlibtorr/nostr-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "litterminal" ]] ; then
export ONION_ADDR_LITTERMINAL="$(sudo cat /litterminal-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "btcpay" ]] ; then

    if [[ -e /lib/tvar/or/btcpay-service ]] ; then
    export ONION_ADDR_BTCPAY="$(sudo cat /var/lib/tor/btcpay-service/hostname 2>/dev/null)" 
    elif [[ -e /var/lib/tor/btcpayTOR-server ]] ; then
    export ONION_ADDR_BTCPAY="$(sudo cat /var/lib/tor/btcpayTOR-server/hostname 2>/dev/null)" 
    fi

return 0
fi

}