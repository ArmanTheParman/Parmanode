function get_onion_address_variable {

if [[ $1 == "bitcoin" ]] ; then
export ONION_ADDR="$(sudo cat /var/lib/tor/${1}-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "fulcrum" ]] ; then
export ONION_ADDR_FULCRUM="$(sudo cat /var/lib/tor/$1-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "bre" ]] ; then
export ONION_ADDR_BRE="$(sudo cat /var/lib/tor/$1-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "electrs" ]] ; then
export ONION_ADDR_ELECTRS="$(sudo cat /var/lib/tor/$1-service/hostname 2>/dev/null)" 
return 0
fi

if [[ $1 == "rtl" ]] ; then
export ONION_ADDR_RTL="$(sudo cat /var/lib/tor/$1-service/hostname 2>/dev/null)"
return 0
fi

if [[ $1 == "mempool" ]] ; then
export ONION_ADDR_MEM="$(sudo cat /var/lib/tor/$1-service/hostname 2>/dev/null)"
return 0
fi


}