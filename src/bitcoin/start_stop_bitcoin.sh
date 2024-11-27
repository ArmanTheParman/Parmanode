# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function restart_bitcoin { stop_bitcoin ; start_bitcoin ; }

function start_bitcoin {
#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] ; then
please_wait
pn_tmux "tmux new -d -s bitcoin 'bitcoind -conf=$HOME/.bitcoin/bitcoin.conf' >$dn 2>&1"
return 0
fi


#needs to be first...
if grep -q btccombo $ic ; then

    pn_tmux "
    if ! docker ps | grep -q btcpay ; then
        docker start btcpay >$dn 2>&1 ; sleep 3
    fi

    docker exec -it btcpay bitcoind
    "

return 0
fi

if [[ $OS == "Linux" ]] ; then 
        pn_tumx "
        if grep -q "drive=external" $pc >$dn ; then mount_drive ; fi
        sudo systemctl start bitcoind.service 
        "
fi                 

if [[ $(uname) == Darwin ]] ; then
        if grep -q "drive=external" $pc >$dn ; then
                if ! mount | grep -q /Volumes/parmanode ; then
                announce "Drive needs to be mounted"
                return 1
                fi
        fi
        run_bitcoinqt
fi
}


########################################################################################################################

function stop_bitcoin {

#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] ; then
pn_tmux "pkill bitcoind" 
return 0
fi

#needs to be first...
if grep -q btccombo $ic ; then
pn_tmux "
docker exec -it btcpay pkill bitcoind
"
return 0
fi

if [[ $OS == "Linux" ]] ; then 
pn_tmux "
sudo systemctl stop bitcoind.service 
"
fi

if [[ $OS == "Mac" ]] ; then
stop_bitcoinqt
fi
}

function start_bitcoin_indocker {
pn_tmux "
docker exec -itu parman btcpay bitcoind
"
}

function stop_bitcoin_docker {
pn_tmux "
docker exec -itu parman btcpay bitcoin-cli stop
"
}
