function get_onion_address_variable {

if [[ $1 == "bitcoin" ]] ; then
export ONION_ADDR="$(sudo cat /var/lib/tor/bitcoin-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "fulcrum" ]] ; then
export ONION_ADDR_FULCRUM="$(sudo cat /var/lib/tor/fulcrum-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "bre" ]] ; then
export ONION_ADDR_BRE="$(sudo cat /var/lib/tor/bre-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "electrs" ]] ; then
export ONION_ADDR_ELECTRS="$(sudo cat /var/lib/tor/electrs-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "rtl" ]] ; then
export ONION_ADDR_RTL="$(sudo cat /var/lib/tor/rtl-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "mempool" ]] ; then
export ONION_ADDR_MEM="$(sudo cat /var/lib/tor/mempool-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "ssh " ]] ; then
export ONION_ADDR_SSH="$(sudo cat /var/lib/tor/ssh-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "public_pool" ]] ; then
export ONION_ADDR_PP="$(sudo cat /var/lib/tor/public_pool-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "electrumx" ]] ; then
export ONION_ADDR_ELECTRUMX="$(sudo cat /var/lib/tor/electrumx-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "website" ]] ; then
export ONION_ADDR_WEBSITE="$(sudo cat /var/lib/tor/website-service/hostname 2>/dev/null)" 
return 0
fi
}