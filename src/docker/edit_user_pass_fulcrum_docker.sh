function edit_user_pass_fulcrum_docker {

#from the host machine
rpcuser=$(grep -w "rpcuser" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')
rpcpassword=$(grep -w "rpcpassword" $HOME/.bitcoin/bitcoin.conf | awk -F '=' '{print $2}')

if docker ps | grep fulcrum >/dev/null 2>&1 ; then
    { docker exec -d -u parman fulcrum /bin/bash -c \
    "source ~/.bashrc && edit_user_pass_fulcrum_conf_indocker $rpcuser $rpcpassword" \
    && log "fulcrum" "docker exec edit user pass fulcrum indocker has run" ; } \
    || { log "fulcrum" "Failed to run edit_user_pass_fulcrum_conf_indocker" && return 1 ; }
    fi

return 0
}

