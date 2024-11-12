
function make_joinmarket_config {
    jmfile="/root/.joinmarket/joinmarket.cfg"
    source $bc
#    enter_continue "rpcuser: $rpcuser, rpcpassword: $rpcpassword"
    docker exec joinmarket bash -c "sed -i '/rpc_cookie_file =/d' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_wallet_file =/c\\rpc_wallet_file = jm_wallet' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_user =/c\\rpc_user = $rpcuser' $jmfile"
    docker exec joinmarket bash -c "sed -i '/rpc_password =/c\\rpc_password = $rpcpassword' $jmfile"
    #change first instance of onion_serving_port, leave the second alone
    docker exec joinmarket bash -c "sed -i '0,/onion_serving_port =/c\\onion_serving_port = 8077' $jmfile"

    if [[ $OS == Mac ]] ; then
    docker exec joinmarket bash -c "sed -i '/rpc_host =/c\\rpc_host = host.docker.internal' $jmfile"
    fi

    return 0
}
