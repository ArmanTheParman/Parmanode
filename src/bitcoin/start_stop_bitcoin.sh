# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function restart_bitcoin { stop_bitcoin ; start_bitcoin ; }

function start_bitcoin {
#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] && which bitcoind >$dn ; then
please_wait
pn_tmux "bitcoind -conf=$HOME/.bitcoin/bitcoin.conf" "starting_bitcoin"
sleep 0.5
return 0
fi


#needs to be first...
if grep -q btccombo $ic ; then

    pn_tmux "
    if ! docker ps | grep -q btcpay ; then
        docker start btcpay >$dn 2>&1 ; sleep 3
    fi

    docker exec -it btcpay bitcoind
    " "starting_bitcoin"

sleep 0.5
return 0
fi

if [[ $OS == "Linux" ]] ; then 
    if grep -q "drive=external" $pc ; then mount_drive ; fi 
    sudo systemctl start bitcoind.service
    sleep 0.5
fi                 

if [[ $(uname) == "Darwin" ]] ; then
        if grep -q "drive=external" $pc >$dn ; then
                if ! mount | grep -q /Volumes/parmanode ; then
                announce "Drive needs to be mounted"
                return 1
                fi
        fi
        start_bitcoinqt
        sleep 0.5
        return 0
fi
debug "end start bitcoin"
}


########################################################################################################################

function stop_bitcoin {

#for docker (no systemctl, use tmux)
if [[ -e /.dockerenv ]] ; then
pn_tmux "pkill bitcoind >/dev/null" "stopping_bitcoin"
sleep 0.5
debug "stop_bitcoin 60"
return 0
fi

#needs to be first...
if grep -q btccombo $ic ; then
pn_tmux "
docker exec -it btcpay pkill bitcoind >/dev/null
" "stopping_bitcoin"
sleep 0.5
debug "stop_bitcoin 70"
return 0
fi

if [[ $OS == "Linux" ]] ; then 
sudo systemctl stop bitcoind.service  >/dev/null
sleep 0.5
debug "stop_bitcoin 77"
return 0
fi

if [[ $OS == "Mac" ]] ; then
stop_bitcoinqt
sleep 0.5
debug "stop_bitcoin 84"
return 0
fi
}

function start_bitcoin_indocker {
pn_tmux "
docker exec -itu parman btcpay bitcoind
" "starting_bitcoin"
sleep 0.5
}

function stop_bitcoin_docker {
pn_tmux "
docker exec -itu parman btcpay bitcoin-cli stop
" "stopping_bitcoin"
sleep 0.5
debug "stop_bitcoin_docker 101"
return 0
}

function stop_bitcoinqt {
if [[ $OS == "Mac" ]] ; then

    if [[ $1 == "force" ]] ; then pn_tmux "killall Bitcoin-Qt" "stopping_bitcoin" ; fi

    pn_tmux "pkill -15 Bitcoin-Qt" "stopping_bitcoin"
#    while pgrep "Bitcoin-Qt" >$dn; do
#    sleep 1
#    done

elif [[ $OS == "Linux" ]] ; then
    pn_tmux "pkill -15 bitcoin-qt" "stopping_bitcoin"
#    while pgrep bitcoin-qt >$dn ; do
#    sleep 0.5
#    done
fi

}
function start_bitcoinqt {
if [[ $OS == "Mac" ]] ; then
    pn_tmux "open /Applications/Bitcoin-Qt.app" "starting_bitcoin"
    sleep 0.5
    return 0
elif [[ $OS == "Linux" ]] ; then
    if pgrep bitcoin >$dn 2>&1 ; then return 1 ; fi
    nohup bitcoin-qt >$dn 2>&1 &
    sleep 1
    return 0
fi
}
