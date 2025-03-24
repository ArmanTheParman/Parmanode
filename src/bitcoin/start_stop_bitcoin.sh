# I have used the name bitcoind, but later introduced bitcoin-qt for macs, the name of the function
# has been kept the same

function restart_bitcoin { stop_bitcoin ; start_bitcoin ; }

function start_bitcoin {
#for podman (no systemctl, use tmux)
if [[ -e /.podmanenv ]] && which bitcoind >$dn ; then
please_wait
pn_tmux "bitcoind -conf=$HOME/.bitcoin/bitcoin.conf" "starting_bitcoin"
sleep 0.5
return 0
fi


#needs to be first...
if grep -q btccombo $ic ; then

    pn_tmux "
    if ! podman ps | grep -q btcpay ; then
        podman start btcpay >$dn 2>&1 ; sleep 3
    fi

    podman exec -it btcpay bitcoind
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
}


########################################################################################################################

function stop_bitcoin {

#for podman (no systemctl, use tmux)
if [[ -e /.podmanenv ]] ; then
pn_tmux "pkill bitcoind" "stopping_bitcoin"
sleep 0.5
return 0
fi

#needs to be first...
if grep -q btccombo $ic ; then
pn_tmux "
podman exec -it btcpay pkill bitcoind
" "stopping_bitcoin"
sleep 0.5
return 0
fi

if [[ $OS == "Linux" ]] ; then 
sudo systemctl stop bitcoind.service 
sleep 0.5
return 0
fi

if [[ $OS == "Mac" ]] ; then
stop_bitcoinqt
sleep 0.5
return 0
fi
}

function start_bitcoin_inpodman {
pn_tmux "
podman exec -itu parman btcpay bitcoind
" "starting_bitcoin"
sleep 0.5
}

function stop_bitcoin_podman {
pn_tmux "
podman exec -itu parman btcpay bitcoin-cli stop
" "stopping_bitcoin"
sleep 0.5
return 0
}

function stop_bitcoinqt {
if [[ $OS == Mac ]] ; then

    if [[ $1 == force ]] ; then pn_tmux "killall Bitcoin-Qt" "stopping_bitcoin" ; fi

    pn_tmux "pkill -15 Bitcoin-Qt" "stopping_bitcoin"
#    while pgrep "Bitcoin-Qt" >$dn; do
#    sleep 1
#    done

elif [[ $OS == Linux ]] ; then
    pn_tmux "pkill -15 bitcoin-qt" "stopping_bitcoin"
#    while pgrep bitcoin-qt >$dn ; do
#    sleep 0.5
#    done
fi

}
function start_bitcoinqt {
if [[ $OS == Mac ]] ; then
    pn_tmux "open /Applications/Bitcoin-Qt.app" "starting_bitcoin"
    sleep 0.5
    return 0
elif [[ $OS == Linux ]] ; then
    if pgrep bitcoin >$dn 2>&1 ; then return 1 ; fi
    nohup bitcoin-qt >$dn 2>&1 &
    sleep 1
    return 0
fi
}
