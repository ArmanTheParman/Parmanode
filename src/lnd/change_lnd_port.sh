function change_lnd_port {

if grep -r "lnddocker-" < $ic ; then
announce "It is not possible to change the LND port if running inside
    a Docker container, as the ports are already 'bound' when running
    the container. 9735 it shall remain. 
    
    To change, you'd have to re-install LND yourself without Parmanode. 
    Aborting."
    return 1
fi

set_lnd_port || return 1
get_extIP
swap_string "$HOME/.lnd/lnd.conf" "externalip=" "externalip=$extIP:$lnd_port"
swap_string "$HOME/.lnd/lnd.conf" "listen=0.0.0.0:973" "listen=0.0.0.0:$lnd_port"
restart_lnd
return 0
}