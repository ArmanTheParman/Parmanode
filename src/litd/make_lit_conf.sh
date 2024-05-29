function make_lit_conf {
file="$HOME/.lit/lit.conf"

source $HOME/.bitcoin/bitcoin.conf

get_extIP >/dev/null 2>&1

if grep -q "litdocker" < $ic || [[ $install == litdocker ]] ; then
customHOME=/home/parman
else
customHOME=$HOME
fi

if [[ -z $ipcore ]] ; then ipcore="127.0.0.1"
else
    if [[ -n $remote_user ]] && [[ -n $remote_pass ]] ; then
        rpcuser=$remote_user
        rpcpassword=$remote_pass
    else
        announce "Unexpected absence of remote user/pass values. Using defaults instead."
    fi 
fi

echo "
lnd-mode=integrated
uipassword=<xxx>

lnd.tlsextraip=0.0.0.0
lnd.externalip=$extIP:$lnd_port
lnd.tlsautorefresh=true
lnd.adminmacaroonpath=~/.lit/data/chain/bitcoin/mainnet/admin.macaroon
lnd.readonlymacaroonpath=~/.lit/data/chain/bitcoin/mainnet/readonly.macaroon
lnd.invoicemacaroonpath=~/.lit/data/chain/bitcoin/mainnet/invoice.macaroon
lnd.listen=0.0.0.0:9735
lnd.rpclisten=0.0.0.0:10009
lnd.restlisten=0.0.0.0:8080
lnd.maxpendingchannels=2
; lnd.wallet-unlock-password-file=$customHOME/.lit/password.txt
; lnd.wallet-unlock-allow-create=true
lnd.minchansize=200000
lnd.alias=$alias
lnd.bitcoin.active=true
lnd.bitcoin.mainnet=true
lnd.bitcoin.node=bitcoind
lnd.bitcoin.defaultchanconfs=3
lnd.bitcoin.basefee=5000
lnd.bitcoin.feerate=50
lnd.bitcoind.rpcuser=$rpcuser
lnd.bitcoind.rpcpass=$rpcpassword
lnd.bitcoind.zmqpubrawblock=tcp://$ipcore:28332
lnd.bitcoind.zmqpubrawtx=tcp://$ipcore:28333
lnd.bitcoind.rpchost=$ipcore
lnd.protocol.wumbo-channels=true
lnd.rpcmiddleware.enable=true
" | tee $file >/dev/null 2>&1

if [[ $bitcoin_choice_with_lnd == local ]] \
&& [[ $install == litdocker ]] && [[ $OS == Mac ]] ; then
swap_string "$file" "bitcoind.zmqpubrawblock=" "lnd.bitcoind.zmqpubrawblock=tcp://host.docker.internal:28332"
swap_string "$file" "bitcoind.zmqpubrawtx=" "lnd.bitcoind.zmqpubrawtx=tcp://host.docker.internal:28333"
fi
} 