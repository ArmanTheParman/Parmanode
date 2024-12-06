
function make_joinmarket_config {
    jmfile="$HOME/.joinmarket/joinmarket.cfg"
    source $bc

    gsed -i '/rpc_port=/c\rpc_port = 8332' $jmfile
    gsed -i '/rpc_cookie_file =/d' $jmfile
    gsed -i '/rpc_wallet_file =/c\rpc_wallet_file = jm_wallet' $jmfile
    gsed -i "/rpc_user =/c\rpc_user = $rpcuser" $jmfile
    gsed -i "/rpc_password =/c\rpc_password = $rpcpassword" $jmfile

    #change first instance of onion_serving_port, leave the second alone
    gsed -i '0,/onion_serving_port =/{s/onion_serving_port =.*/onion_serving_port = 8077/}' $jmfile
    
    add_directory_nodes
    debug "after add_directory_nodes"

    return 0
}


function add_directory_nodes {

if ! grep -q "3kxw6lf5vf6y26emzwgibzhrzhmhqiw6ekrek3nqfjjmhwznb2moonad.onion:5222" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, 3kxw6lf5vf6y26emzwgibzhrzhmhqiw6ekrek3nqfjjmhwznb2moonad.onion:5222/' $jmfile 2>$dn
fi
if ! grep -q "bqlpq6ak24mwvuixixitift4yu42nxchlilrcqwk2ugn45tdclg42qid.onion:5222" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, bqlpq6ak24mwvuixixitift4yu42nxchlilrcqwk2ugn45tdclg42qid.onion:5222/' $jmfile 2>$dn
fi
if ! grep -q "plq5jw5hqke6werrc5duvgwbuczrg4mphlqsqbzmdfwxwkm2ncdzxeqd.onion:5222" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, plq5jw5hqke6werrc5duvgwbuczrg4mphlqsqbzmdfwxwkm2ncdzxeqd.onion:5222/' $jmfile 2>$dn
fi
if ! grep -q "odpwaf67rs5226uabcamvypg3y4bngzmfk7255flcdodesqhsvkptaid.onion:5222" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, odpwaf67rs5226uabcamvypg3y4bngzmfk7255flcdodesqhsvkptaid.onion:5222/' $jmfile 2>$dn
fi
if ! grep -q "ylegp63psfqh3zk2huckf2xth6dxvh2z364ykjfmvsoze6tkfjceq7qd.onion:5222/" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, ylegp63psfqh3zk2huckf2xth6dxvh2z364ykjfmvsoze6tkfjceq7qd.onion:5222/' $jmfile 2>$dn
fi
if ! grep -q "wkd3kd73ze62sqhlj2ebwe6fxqvshw5sya6nkvrgcweegt7ljhuspaid.onion:5222/" $jmfile ; then
gsed -i '/directory_nodes =/s/$/, wkd3kd73ze62sqhlj2ebwe6fxqvshw5sya6nkvrgcweegt7ljhuspaid.onion:5222/' $jmfile 2>$dn
fi

}


