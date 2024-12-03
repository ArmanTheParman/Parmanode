
function make_joinmarket_config {
    jmfile="$HOME/.joinmarket/joinmarket.cfg"
    source $bc

    gsed -i '/rpc_port=/c\\rpc_port = 8332' $jmfile
    gsed -i '/rpc_cookie_file =/d' $jmfile
    gsed -i '/rpc_wallet_file =/c\\rpc_wallet_file = jm_wallet' $jmfile
    gsed -i '/rpc_user =/c\\rpc_user = $rpcuser' $jmfile
    gsed -i '/rpc_password =/c\\rpc_password = $rpcpassword' $jmfile

    #change first instance of onion_serving_port, leave the second alone
    gsed -i '0,/onion_serving_port =/{s/onion_serving_port =.*/onion_serving_port = 8077/}' $jmfile


    if [[ $joinmarket_docker == "true" && $OS == "Mac" ]] ; then
    gsed -i '/rpc_host =/c\\rpc_host = host.docker.internal' $jmfile
    fi

    return 0
}
