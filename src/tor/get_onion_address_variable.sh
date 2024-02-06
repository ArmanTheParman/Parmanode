function get_onion_address_variable {
debug "in goav, 1 is $1"

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

if [[ $1 == "ssh" ]] ; then
export ONION_ADDR_SSH="$(sudo cat /var/lib/tor/ssh-service/hostname 2>/dev/null)" 
debug "pause"
return 0
fi

debug "finished get onion address variable"
fi
}