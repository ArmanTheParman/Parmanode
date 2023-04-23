function edit_user_pass_fulcrum_docker {
#from the host machine
if [[ -z $1 || -z $2 ]] ; then
    rpcuser=$(grep -w "rpcuser" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')
    rpcpassword=$(grep -w "rpcpassword" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')
else
rpcuser=$1
rpcpassword=$2
fi

if docker ps | grep fulcrum >/dev/null 2>&1 ; then
    { docker exec -d -u parman fulcrum /bin/bash -c \
    "source /home/parman/parmanode/src/edit_user_pass_fulcrum_conf_indocker.sh ; \
    edit_user_pass_fulcrum_conf_indocker $rpcuser $rpcpassword" \
    && log "fulcrum" "docker exec edit user pass fulcrum indocker has run" && return 0 ; } \
    || { log "fulcrum" "Failed to run edit_user_pass_fulcrum_conf_indocker" && return 1 ; }
else
    set_terminal ; echo "Fulcrum Docker container is not running - can't change username and password inside container. Aborting."
    log "fulcrum" "Unable to change user/pass because fulcrum container not running."
    enter_continue
    return 1
fi

return 1 
}