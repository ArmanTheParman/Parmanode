function get_onion_address_variable {

if [[ $1 == "bitcoin" ]] ; then
ONION_ADDR="$(sudo cat /var/lib/tor/$1-service/hostname)" 
return 0
fi

if [[ $1 == "fulcrum" ]] ; then
ONION_ADDR_FULCRUM="$(sudo cat /var/lib/tor/$1-service/hostname)" 
return 0
fi

}